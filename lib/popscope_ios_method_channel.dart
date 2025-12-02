import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'popscope_ios_platform_interface.dart';

/// An implementation of [PopscopeIosPlatform] that uses method channels.
class MethodChannelPopscopeIos extends PopscopeIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('popscope_ios');

  /// Callback for system back gesture
  VoidCallback? _onSystemBackGesture;
  
  /// Navigator key for automatic navigation handling
  GlobalKey<NavigatorState>? _navigatorKey;
  
  /// Whether to automatically handle navigation
  bool _autoHandleNavigation = false;
  
  /// Whether the method call handler has been set
  bool _handlerInitialized = false;

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
  }
  
  @override
  void setNavigatorKey(GlobalKey<NavigatorState>? navigatorKey, {bool autoHandle = true}) {
    _ensureHandlerInitialized();
    _navigatorKey = navigatorKey;
    _autoHandleNavigation = autoHandle;
  }

  @override
  Future<void> setup() async {
    _ensureHandlerInitialized();
    await methodChannel.invokeMethod<void>('setup');
  }

  @override
  Future<String?> getPlatformVersion() async {
    _ensureHandlerInitialized();
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
