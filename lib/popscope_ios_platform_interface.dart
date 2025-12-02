import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'popscope_ios_method_channel.dart';

abstract class PopscopeIosPlatform extends PlatformInterface {
  /// Constructs a PopscopeIosPlatform.
  PopscopeIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static PopscopeIosPlatform _instance = MethodChannelPopscopeIos();

  /// The default instance of [PopscopeIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelPopscopeIos].
  static PopscopeIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PopscopeIosPlatform] when
  /// they register themselves.
  static set instance(PopscopeIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// 设置系统返回手势的回调
  void setOnSystemBackGesture(VoidCallback? callback) {
    throw UnimplementedError('setOnSystemBackGesture() has not been implemented.');
  }
  
  /// 设置 Navigator key 以支持自动导航处理
  void setNavigatorKey(GlobalKey<NavigatorState>? navigatorKey, {bool autoHandle = true}) {
    throw UnimplementedError('setNavigatorKey() has not been implemented.');
  }
}
