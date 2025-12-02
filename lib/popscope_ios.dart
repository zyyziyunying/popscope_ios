import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'popscope_ios_platform_interface.dart';

class PopscopeIos {
  Future<String?> getPlatformVersion() {
    return PopscopeIosPlatform.instance.getPlatformVersion();
  }

  /// 手动触发插件设置
  /// 
  /// 通常不需要调用此方法，插件会在初始化时自动设置。
  /// 但如果自动设置失败，可以手动调用此方法。
  /// 
  /// 示例：
  /// ```dart
  /// final plugin = PopscopeIos();
  /// await plugin.setup();
  /// ```
  Future<void> setup() {
    return PopscopeIosPlatform.instance.setup();
  }

  /// 设置 Navigator key 以支持自动导航处理
  /// 
  /// 当设置了 Navigator key 并启用自动处理后，插件会在检测到系统返回手势时
  /// 自动调用 `Navigator.maybePop()`。
  /// 
  /// 参数：
  /// - [navigatorKey]: MaterialApp 或 CupertinoApp 的 navigatorKey
  /// - [autoHandle]: 是否自动处理导航（默认为 true）
  /// 
  /// 示例 1：自动处理导航（推荐）
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// final plugin = PopscopeIos();
  /// 
  /// void main() {
  ///   plugin.setNavigatorKey(navigatorKey);
  ///   runApp(MaterialApp(
  ///     navigatorKey: navigatorKey,
  ///     home: MyHomePage(),
  ///   ));
  /// }
  /// ```
  /// 
  /// 示例 2：只在需要时手动控制
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// final plugin = PopscopeIos();
  /// 
  /// plugin.setNavigatorKey(navigatorKey, autoHandle: false);
  /// plugin.setOnSystemBackGesture(() {
  ///   // 自定义逻辑，例如显示确认对话框
  ///   showDialog(...);
  /// });
  /// ```
  void setNavigatorKey(GlobalKey<NavigatorState>? navigatorKey, {bool autoHandle = true}) {
    PopscopeIosPlatform.instance.setNavigatorKey(navigatorKey, autoHandle: autoHandle);
  }

  /// 设置系统返回手势的回调
  /// 
  /// 当用户在 iOS 设备上执行左滑返回手势时，会触发此回调。
  /// 你可以在回调中执行自定义逻辑，例如显示确认对话框、保存数据等。
  /// 
  /// 注意：如果使用 `setNavigatorKey` 并启用了 autoHandle，
  /// 系统会先自动调用 `maybePop()`，然后再调用此回调。
  /// 
  /// 示例：
  /// ```dart
  /// final plugin = PopscopeIos();
  /// plugin.setOnSystemBackGesture(() {
  ///   print('检测到系统返回手势');
  ///   // 在这里执行自定义逻辑
  /// });
  /// ```
  void setOnSystemBackGesture(VoidCallback? callback) {
    PopscopeIosPlatform.instance.setOnSystemBackGesture(callback);
  }
}
