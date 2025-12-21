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
  ///
  /// 当检测到 iOS 左滑返回手势时，会调用此回调函数。
  ///
  /// 参数：
  /// - [callback]: 手势触发时的回调函数，传入 null 可清除回调
  ///
  /// ⚠️ 注意：此方法会直接替换回调，多个页面使用时会有覆盖问题。
  /// 推荐使用 [registerPopGestureCallback] 和 [unregisterPopGestureCallback] 来管理回调。
  @Deprecated(
    '直接调用这个方法，会直接影响全局，多个页面使用时会有覆盖问题'
    '请使用 registerPopGestureCallback 和 unregisterPopGestureCallback 来管理回调',
  )
  void setOnSystemBackGesture(VoidCallback? callback) {
    throw UnimplementedError(
      'setOnSystemBackGesture() has not been implemented.',
    );
  }

  /// 注册系统返回手势的回调
  ///
  /// 当检测到 iOS 左滑返回手势时，会调用栈顶的回调函数。
  /// 多个页面可以同时注册回调，只有栈顶（最后注册）的回调会被调用。
  ///
  /// 参数：
  /// - [callback]: 手势触发时的回调函数
  /// - [context]: 可选，注册回调时的 BuildContext，用于检查页面是否还在顶层
  ///              如果提供，只有当该页面还在顶层时才会调用回调
  ///
  /// 返回：
  /// - [Object]: 回调标识符，用于后续注销回调
  ///
  /// 示例：
  /// ```dart
  /// final token = PopscopeIos.registerPopGestureCallback(() {
  ///   print('手势触发');
  /// }, context);
  ///
  /// // 组件销毁时注销
  /// PopscopeIos.unregisterPopGestureCallback(token);
  /// ```
  Object registerPopGestureCallback(
    VoidCallback callback, [
    BuildContext? context,
  ]) {
    throw UnimplementedError(
      'registerPopGestureCallback() has not been implemented.',
    );
  }

  /// 注销系统返回手势的回调
  ///
  /// 参数：
  /// - [token]: 注册回调时返回的标识符
  void unregisterPopGestureCallback(Object token) {
    throw UnimplementedError(
      'unregisterPopGestureCallback() has not been implemented.',
    );
  }

  /// 设置 Navigator key 以支持自动导航处理
  ///
  /// 通过设置 NavigatorKey，插件可以在检测到左滑返回手势时自动调用 `maybePop()`。
  ///
  /// 参数：
  /// - [navigatorKey]: 全局 Navigator Key
  /// - [autoHandle]: 是否自动处理导航，默认为 true
  @Deprecated(
    '直接调用这个方法，会直接影响全局，并且不是很有必要'
    '请使用 registerPopGestureCallback 和 unregisterPopGestureCallback 来管理回调',
  )
  void setNavigatorKey(
    GlobalKey<NavigatorState>? navigatorKey, {
    bool autoHandle = true,
  }) {
    throw UnimplementedError('setNavigatorKey() has not been implemented.');
  }
}
