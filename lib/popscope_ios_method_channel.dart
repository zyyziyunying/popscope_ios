import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'popscope_ios_platform_interface.dart';

/// 使用 Method Channel 实现的 [PopscopeIosPlatform]
/// 
/// 该类负责与 iOS 原生端通信，接收左滑返回手势事件并处理。
class MethodChannelPopscopeIos extends PopscopeIosPlatform {
  /// 用于与原生平台交互的 Method Channel
  @visibleForTesting
  final methodChannel = const MethodChannel('popscope_ios');

  /// 系统返回手势的回调函数
  VoidCallback? _onSystemBackGesture;
  
  /// 用于自动导航处理的 Navigator Key
  GlobalKey<NavigatorState>? _navigatorKey;
  
  /// 是否自动处理导航
  bool _autoHandleNavigation = false;
  
  /// Method Call Handler 是否已初始化
  bool _handlerInitialized = false;

  /// iOS 端手势拦截是否已启用
  bool _iosGestureEnabled = false;

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
        debugPrint('PopscopeIos: Method call handler will be initialized later');
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
        _onSystemBackGesture?.call();
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
    _enableIosGestureIfNeeded();
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
      } catch (e) {}
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
