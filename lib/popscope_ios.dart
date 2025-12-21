import 'package:flutter/material.dart';
import 'popscope_ios_platform_interface.dart';
import 'utils/logger.dart';

// 导出 widgets，方便用户使用
export 'widgets/platform_popscope.dart';
export 'widgets/ios_pop_interceptor.dart';

/// iOS 左滑返回手势拦截插件
///
/// 该插件用于拦截 iOS 系统的左滑返回手势（interactivePopGesture），
/// 支持三种使用方式：
/// 1. **推荐**：使用 [PlatformPopScope] widget，自动处理初始化和销毁
/// 2. **推荐**：使用 [IosNavigatorKeyInterceptor] widget，在组件级别管理 setNavigatorKey
/// 3. 自动处理：通过 [setNavigatorKey] 设置 Navigator，插件自动调用 maybePop()（不推荐全局设置）
/// 4. 业务自定义：通过 [setOnLeftBackGesture] 设置回调，由业务层自行处理（不推荐全局设置）
///
/// **强烈推荐使用组件方式（[PlatformPopScope] 或 [IosNavigatorKeyInterceptor]）**，
/// 它们会自动处理资源管理和生命周期，避免全局配置导致的问题（如多次 pop）。
///
/// ⚠️ **警告**：直接在 main() 中全局设置 [setNavigatorKey] 或 [setOnLeftBackGesture]
/// 可能导致多个页面同时响应返回手势，造成多次 pop 的问题。
/// 建议使用组件方式，在需要处理的页面中包裹相应的 widget。
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
  @Deprecated(
    '直接调用这个方法，会直接影响全局，并且不是很有必要'
    '请使用 registerPopGestureCallback 和 unregisterPopGestureCallback 来管理回调',
  )
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
  /// - ⚠️ 此方法会直接替换回调，多个页面使用时会有覆盖问题
  /// - 推荐使用 [registerPopGestureCallback] 和 [unregisterPopGestureCallback] 来管理回调
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
  @Deprecated(
    '直接调用这个方法，会直接影响全局，多个页面使用时会有覆盖问题'
    '请使用 registerPopGestureCallback 和 unregisterPopGestureCallback 来管理回调',
  )
  static void setOnLeftBackGesture(VoidCallback? callback) {
    PopscopeIosPlatform.instance.setOnSystemBackGesture(callback);
  }

  /// 注册左滑返回手势的回调函数
  ///
  /// 当 iOS 系统检测到左滑返回手势时，会调用栈顶的回调函数。
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
  /// 使用场景：
  /// - 多个页面都需要拦截返回手势时，使用此方法可以避免回调覆盖
  /// - 组件销毁时需要清理回调，避免内存泄漏
  /// - 当路由是 A->B->C，B 页面注册了回调，C 页面没有注册回调时，
  ///   只有 B 页面还在顶层时才会调用 B 页面的回调
  ///
  /// 示例：
  /// ```dart
  /// class MyPage extends StatefulWidget {
  ///   @override
  ///   State<MyPage> createState() => _MyPageState();
  /// }
  ///
  /// class _MyPageState extends State<MyPage> {
  ///   Object? _callbackToken;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     _callbackToken = PopscopeIos.registerPopGestureCallback(() {
  ///       print('检测到左滑返回手势');
  ///       // 处理返回逻辑
  ///     }, context);
  ///   }
  ///
  ///   @override
  ///   void dispose() {
  ///     if (_callbackToken != null) {
  ///       PopscopeIos.unregisterPopGestureCallback(_callbackToken!);
  ///     }
  ///     super.dispose();
  ///   }
  /// }
  /// ```
  static Object registerPopGestureCallback(
    VoidCallback callback, [
    BuildContext? context,
  ]) {
    final token = PopscopeIosPlatform.instance.registerPopGestureCallback(
      callback,
      context,
    );
    PopscopeLogger.info(
      'registerPopGestureCallback token: $token, context: $context',
    );
    return token;
  }

  /// 注销左滑返回手势的回调函数
  ///
  /// 参数：
  /// - [token]: 注册回调时返回的标识符
  ///
  /// 示例：
  /// ```dart
  /// final token = PopscopeIos.registerPopGestureCallback(() {
  ///   print('手势触发');
  /// });
  ///
  /// // 组件销毁时注销
  /// PopscopeIos.unregisterPopGestureCallback(token);
  /// ```
  static void unregisterPopGestureCallback(Object token) {
    PopscopeIosPlatform.instance.unregisterPopGestureCallback(token);
    PopscopeLogger.info('unregisterPopGestureCallback token: $token');
  }
}
