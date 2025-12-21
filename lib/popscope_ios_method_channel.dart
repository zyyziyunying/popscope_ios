import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'popscope_ios_platform_interface.dart';

/// 回调条目，包含回调函数和唯一标识符
class _CallbackEntry {
  final Object token;
  final VoidCallback callback;

  /// 注册回调时的 BuildContext，用于检查页面是否还在顶层
  final BuildContext? context;

  _CallbackEntry(this.token, this.callback, this.context);

  /// 检查该回调是否应该被调用
  /// 只有当注册该回调的页面还在顶层时才返回 true
  bool shouldInvoke() {
    if (context == null) {
      // 如果没有 context，默认允许调用（兼容旧版 API）
      return true;
    }

    // 检查 context 是否还 mounted
    if (!context!.mounted) {
      return false;
    }

    // 检查该页面的 Route 是否还在顶层
    try {
      final route = ModalRoute.of(context!);
      if (route == null) {
        return false;
      }

      // 如果 route.isCurrent 为 true，说明该 route 是当前顶层 route
      return route.isCurrent;
    } catch (e) {
      // 如果检查过程中出错，说明 context 已失效
      return false;
    }
  }

  /// 检查该回调是否应该被清理
  /// 只有当注册该回调的页面已经被销毁（context unmounted）时才返回 true
  /// 如果页面只是被覆盖但还在路由栈中，不应该清理
  bool shouldRemove() {
    if (context == null) {
      // 如果没有 context，无法判断，不清理（兼容旧版 API）
      return false;
    }

    // 只有当 context 已经 unmounted 时才清理
    // 如果 context 还 mounted，说明页面还在路由栈中，不应该清理
    return !context!.mounted;
  }
}

/// 使用 Method Channel 实现的 [PopscopeIosPlatform]
///
/// 该类负责与 iOS 原生端通信，接收左滑返回手势事件并处理。
class MethodChannelPopscopeIos extends PopscopeIosPlatform {
  /// 用于与原生平台交互的 Method Channel
  @visibleForTesting
  final methodChannel = const MethodChannel('popscope_ios');

  /// 系统返回手势的回调函数（旧版 API，保持兼容）
  VoidCallback? _onSystemBackGesture;

  /// 回调栈，用于管理多个页面的回调
  /// 栈顶（最后一个）的回调会被调用
  final List<_CallbackEntry> _callbackStack = [];

  /// 用于自动导航处理的 Navigator Key
  GlobalKey<NavigatorState>? _navigatorKey;

  /// 是否自动处理导航
  bool _autoHandleNavigation = false;

  /// Method Call Handler 是否已初始化
  bool _handlerInitialized = false;

  /// iOS 端手势拦截是否已启用
  bool _iosGestureEnabled = false;

  /// 回调标识符计数器
  int _tokenCounter = 0;

  MethodChannelPopscopeIos() {
    // 延迟设置 method call handler，避免在 binding 初始化前调用
    _ensureHandlerInitialized();
  }

  /// 确保 method call handler 已设置
  void _ensureHandlerInitialized() {
    if (!_handlerInitialized) {
      try {
        methodChannel.setMethodCallHandler(_handleMethodCall);
        _handlerInitialized = true;
      } catch (e) {
        // 如果 binding 还没初始化，稍后再试
        debugPrint(
          'PopscopeIos: Method call handler will be initialized later',
        );
      }
    }
  }

  /// 处理来自原生端的方法调用
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSystemBackGesture':
        // 当接收到系统返回手势时
        debugPrint('PopscopeIos: onSystemBackGesture pop');
        // 1. 如果设置了自动处理导航，尝试调用 maybePop()
        if (_autoHandleNavigation) {
          final navigator = _navigatorKey?.currentState;
          if (navigator != null) {
            await navigator.maybePop();
          } else {
            debugPrint('PopscopeIos: NavigatorState is null, cannot pop');
          }
        }

        // 2. 调用用户自定义回调（无论是否自动处理）
        // 从栈顶开始查找，找到第一个有效的回调（注册该回调的页面还在顶层）
        VoidCallback? validCallback;
        
        // 先清理已销毁的回调（context unmounted）
        _callbackStack.removeWhere((entry) => entry.shouldRemove());
        
        // 然后从栈顶开始查找有效的回调
        for (var i = _callbackStack.length - 1; i >= 0; i--) {
          final entry = _callbackStack[i];
          if (entry.shouldInvoke()) {
            validCallback = entry.callback;
            break;
          }
        }

        if (validCallback != null) {
          validCallback();
        } else if (_onSystemBackGesture != null) {
          // 兼容旧版 API
          _onSystemBackGesture?.call();
        }
        break;
      default:
        throw MissingPluginException('未实现的方法: ${call.method}');
    }
  }

  @override
  void setOnSystemBackGesture(VoidCallback? callback) {
    _ensureHandlerInitialized();
    _onSystemBackGesture = callback;
    // 当设置回调时，启用 iOS 端的手势拦截
    if (callback != null) {
      _enableIosGestureIfNeeded();
    }
  }

  @override
  Object registerPopGestureCallback(
    VoidCallback callback, [
    BuildContext? context,
  ]) {
    _ensureHandlerInitialized();
    final token = _tokenCounter++;
    _callbackStack.add(_CallbackEntry(token, callback, context));
    // 当注册回调时，启用 iOS 端的手势拦截
    _enableIosGestureIfNeeded();
    return token;
  }

  @override
  void unregisterPopGestureCallback(Object token) {
    _callbackStack.removeWhere((entry) => entry.token == token);
  }

  @override
  void setNavigatorKey(
    GlobalKey<NavigatorState>? navigatorKey, {
    bool autoHandle = true,
  }) {
    _ensureHandlerInitialized();
    _navigatorKey = navigatorKey;
    _autoHandleNavigation = autoHandle;
    // 当设置 Navigator Key 时，启用 iOS 端的手势拦截
    _enableIosGestureIfNeeded();
  }

  /// 如果需要，启用 iOS 端的手势拦截
  ///
  /// 只有在 Flutter 层主动调用 setNavigatorKey 或 setOnSystemBackGesture 时才会启用
  void _enableIosGestureIfNeeded() {
    if (!_iosGestureEnabled) {
      try {
        methodChannel.invokeMethod('enableInteractivePopGesture');
        _iosGestureEnabled = true;
      } catch (e) {
        throw PlatformException(
          code: 'enableInteractivePopGestureError',
          message: 'enableInteractivePopGesture error: $e',
        );
      }
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    _ensureHandlerInitialized();
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
