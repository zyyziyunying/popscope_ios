import 'package:flutter/material.dart';

import 'popscope_ios_platform_interface.dart';

/// iOS 左滑返回手势拦截插件
///
/// 该插件用于拦截 iOS 系统的左滑返回手势（interactivePopGesture），
/// 支持两种处理方式：
/// 1. 自动处理：通过 [setNavigatorKey] 设置 Navigator，插件自动调用 maybePop()
/// 2. 业务自定义：通过 [setOnLeftBackGesture] 设置回调，由业务层自行处理
///
/// 注意：两个方法至少需要设置一个才能使插件生效。
class PopscopeIos {
  Future<String?> getPlatformVersion() {
    return PopscopeIosPlatform.instance.getPlatformVersion();
  }

  /// 设置 Navigator Key，用于自动处理页面返回
  ///
  /// 当 iOS 系统检测到左滑返回手势时，插件会自动调用 `navigator.maybePop()` 来处理页面返回。
  ///
  /// 参数：
  /// - [navigatorKey]: 全局 Navigator Key，通常在 MaterialApp 中设置
  /// - [autoHandle]: 是否自动处理导航，默认为 true
  ///
  /// 使用场景：
  /// - 希望插件自动处理页面返回，无需业务层介入
  /// - 需要与 Flutter 的导航系统集成
  ///
  /// 示例：
  /// ```dart
  /// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ///
  /// void main() {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   PopscopeIos.setNavigatorKey(navigatorKey);
  ///   runApp(MyApp());
  /// }
  ///
  /// class MyApp extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       navigatorKey: navigatorKey, // 关联到 MaterialApp
  ///       home: HomePage(),
  ///     );
  ///   }
  /// }
  /// ```
  static void setNavigatorKey(
    GlobalKey<NavigatorState>? navigatorKey, {
    bool autoHandle = true,
  }) {
    PopscopeIosPlatform.instance.setNavigatorKey(
      navigatorKey,
      autoHandle: autoHandle,
    );
  }

  /// 设置左滑返回手势的回调函数
  ///
  /// 当 iOS 系统检测到左滑返回手势时，会调用此回调函数，由业务层自行处理。
  ///
  /// 参数：
  /// - [callback]: 手势触发时的回调函数，传入 null 可清除回调
  ///
  /// 使用场景：
  /// - 需要在返回前执行自定义逻辑（如保存数据、显示确认对话框等）
  /// - 需要根据业务状态决定是否允许返回
  /// - 需要统计或记录用户的返回行为
  ///
  /// 注意：
  /// - 如果同时设置了 [setNavigatorKey]，会先自动调用 maybePop()，然后再执行此回调
  /// - 如果只设置此回调而不设置 [setNavigatorKey]，则需要在回调中自行处理页面返回
  ///
  /// 示例：
  /// ```dart
  /// void main() {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   // 只设置回调，业务自行处理
  ///   PopscopeIos.setOnLeftBackGesture(() {
  ///     print('检测到左滑返回手势');
  ///     // 这里可以执行自定义逻辑
  ///     // 例如：显示确认对话框、保存数据等
  ///   });
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  static void setOnLeftBackGesture(VoidCallback? callback) {
    PopscopeIosPlatform.instance.setOnSystemBackGesture(callback);
  }
}
