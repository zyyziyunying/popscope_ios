# popscope_ios

一个 Flutter 插件，用于拦截和处理 iOS 系统的侧滑返回手势。

## 功能特性

- 🎯 拦截 iOS 系统的侧滑返回手势（interactivePopGesture）
- 📱 通过 MethodChannel 将手势事件传递给 Flutter 层
- 🎨 允许自定义返回行为（例如：显示确认对话框、保存数据等）
- ⚡️ 简单易用的 API

## 工作原理

插件在初始化时会：
1. 获取 Flutter 应用的 `UIViewController`
2. 查找 `UINavigationController`
3. 将 `interactivePopGestureRecognizer` 的代理设置为插件自身
4. 实现 `UIGestureRecognizerDelegate` 协议
5. 当检测到左滑手势时，通过 MethodChannel 通知 Flutter 层，并阻止系统默认的返回行为

## 安装

在你的 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  popscope_ios: ^0.0.1
```

## 使用方法

### 方式 1：自动处理导航（推荐）⭐️

最简单的使用方式，插件会自动调用 `Navigator.maybePop()`：

```dart
import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

// 1. 创建全局 Navigator Key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // 2. 确保 Flutter 绑定已初始化（重要！）
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. 设置 Navigator Key（启用自动导航处理）
  final plugin = PopscopeIos();
  plugin.setNavigatorKey(navigatorKey);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 3. 将 key 传给 MaterialApp
      home: Scaffold(
        appBar: AppBar(title: Text('Popscope iOS Example')),
        body: Center(child: Text('尝试左滑返回')),
      ),
    );
  }
}
```

就这么简单！当用户执行左滑返回手势时，系统会自动调用 `Navigator.maybePop()` 返回上一页。

### 方式 2：自定义处理（显示确认对话框）

如果你需要在返回前执行一些操作（如显示确认对话框），可以禁用自动处理：

```dart
import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  final plugin = PopscopeIos();
  
  // 设置 Navigator Key，但禁用自动处理
  plugin.setNavigatorKey(navigatorKey, autoHandle: false);
  
  // 自定义返回手势处理
  plugin.setOnSystemBackGesture(() {
    final context = navigatorKey.currentContext;
    if (context != null && Navigator.of(context).canPop()) {
      // 显示确认对话框
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('确认返回'),
            content: Text('您有未保存的内容，确定要返回吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // 关闭对话框
                  Navigator.of(context).pop(); // 返回上一页
                },
                child: Text('确认'),
              ),
            ],
          );
        },
      );
    }
  });
  
  runApp(const MyApp());
}
```

### 方式 3：混合模式（自动返回 + 自定义回调）

自动处理导航的同时，也可以添加自定义回调来执行额外的逻辑：

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final plugin = PopscopeIos();
  
  // 启用自动导航处理
  plugin.setNavigatorKey(navigatorKey);
  
  // 添加自定义回调（在自动返回之后执行）
  plugin.setOnSystemBackGesture(() {
    print('用户执行了返回手势');
    // 记录日志、分析等
  });
  
  runApp(const MyApp());
}
```

### 方式 4：保存数据后返回

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final plugin = PopscopeIos();
  
  plugin.setNavigatorKey(navigatorKey, autoHandle: false);
  
  plugin.setOnSystemBackGesture(() async {
    final context = navigatorKey.currentContext;
    if (context != null && Navigator.of(context).canPop()) {
      // 先保存数据
      await saveData();
      
      // 然后返回
      Navigator.of(context).pop();
    }
  });
  
  runApp(const MyApp());
}
```

### 方式 5：集成 PopScope Widget（Flutter 3.12+）🎯

配合 Flutter 的 `PopScope` widget 使用，实现更细粒度的返回控制：

```dart
import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  final plugin = PopscopeIos();
  
  // 启用自动导航处理
  plugin.setNavigatorKey(navigatorKey);
  
  // （可选）添加日志回调
  plugin.setOnSystemBackGesture(() {
    debugPrint('iOS 侧滑手势被触发');
  });
  
  runApp(MyApp());
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,  // 阻止直接返回
      onPopInvoked: (bool didPop) {
        // iOS 侧滑手势 → 插件拦截 → maybePop() 
        // → PopScope 检测到 canPop=false → 触发此回调
        
        if (!didPop) {
          // 显示确认对话框
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('确认返回'),
              content: Text('确定要离开此页面吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();  // 关闭对话框
                    Navigator.of(context).pop();  // 返回上一页
                  },
                  child: Text('确认'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('My Page')),
        body: Center(child: Text('尝试左滑返回')),
      ),
    );
  }
}
```

**工作流程：**
```
用户左滑 → 插件拦截 → 调用 maybePop() 
         → PopScope 检测到 canPop=false 
         → 触发 onPopInvoked(false)
         → 显示确认对话框
```

**优势：**
- ✅ 统一处理所有返回事件（按钮、手势、系统返回等）
- ✅ 符合 Flutter 设计理念
- ✅ 更好的测试性和可维护性

## API 文档

### `PopscopeIos`

#### 方法

##### `setNavigatorKey(GlobalKey<NavigatorState>? navigatorKey, {bool autoHandle = true})`

设置 Navigator key 以支持自动导航处理。**推荐在 `main()` 函数中调用。**

**参数：**
- `navigatorKey`: MaterialApp 或 CupertinoApp 的 navigatorKey
- `autoHandle`: 是否自动处理导航（默认为 `true`）
  - `true`: 插件会在检测到返回手势时自动调用 `Navigator.maybePop()`
  - `false`: 插件不会自动处理，由用户通过 `setOnSystemBackGesture` 回调自行处理

**示例：**
```dart
final navigatorKey = GlobalKey<NavigatorState>();
final plugin = PopscopeIos();

// 自动处理导航
plugin.setNavigatorKey(navigatorKey);

// 或者禁用自动处理，完全自定义
plugin.setNavigatorKey(navigatorKey, autoHandle: false);
```

##### `setOnSystemBackGesture(VoidCallback? callback)`

设置系统返回手势的回调函数。

**行为说明：**
- 如果启用了 `autoHandle`，系统会**先**自动调用 `maybePop()`，**然后**调用此回调
- 如果禁用了 `autoHandle`，只会调用此回调，需要你手动处理导航

**参数：**
- `callback`: 当检测到系统返回手势时调用的回调函数。传入 `null` 可以移除回调。

**示例：**
```dart
final plugin = PopscopeIos();
plugin.setOnSystemBackGesture(() {
  print('检测到返回手势');
});
```

##### `setup()`

手动触发插件设置。

通常不需要调用此方法，插件会在初始化时自动设置。但如果自动设置失败，可以手动调用。

**返回值：** `Future<void>`

**示例：**
```dart
await plugin.setup();
```

##### `getPlatformVersion()`

获取当前 iOS 系统版本。

**返回值：** `Future<String?>`

**示例：**
```dart
final version = await plugin.getPlatformVersion();
print('iOS Version: $version');
```

## 注意事项

⚠️ **重要提示：**

### 1. 必须调用 `WidgetsFlutterBinding.ensureInitialized()`

在 `main()` 函数中使用插件前，**必须**先调用：

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();  // 必须！
  
  final plugin = PopscopeIos();
  plugin.setNavigatorKey(...);
  
  runApp(MyApp());
}
```

**原因：** 插件需要使用 MethodChannel 来接收来自 iOS 原生端的事件，而 MethodChannel 依赖 Flutter 的绑定系统。如果不调用 `ensureInitialized()`，会导致运行时错误。

### 2. 其他注意事项

- 此插件仅适用于 iOS 平台
- 需要在 `UINavigationController` 环境中才能正常工作
- 回调函数会在主线程执行
- 返回手势被拦截后，需要在回调中手动处理导航逻辑（除非启用了 autoHandle）
- 确保在设置回调时 widget 已经挂载（mounted）

## 运行示例

克隆仓库后，可以运行不同的示例应用：

### 示例 1：自动处理（推荐）
```bash
cd example
flutter run
```

### 示例 2：自定义确认对话框
```bash
cd example
flutter run lib/main_custom.dart
```

### 示例 3：PopScope 集成
```bash
cd example
flutter run lib/main_popscope.dart
```

各示例演示了：
- ✅ 基本的手势拦截
- ✅ 自动导航处理
- ✅ 自定义确认对话框
- ✅ PopScope widget 集成
- ✅ 事件日志和状态监控

详细说明请查看 [example/README.md](example/README.md)

## 技术实现

### iOS 原生端

插件使用 Swift 实现，主要包括：

- `PopscopeIosPlugin`: 主插件类，实现 `FlutterPlugin` 和 `UIGestureRecognizerDelegate`
- 在插件注册时获取 `UIViewController` 并设置手势代理
- 通过 `gestureRecognizerShouldBegin` 方法拦截手势
- 使用 MethodChannel 与 Flutter 层通信

### Flutter 端

- `PopscopeIos`: 主类，提供简单的 API
- `PopscopeIosPlatform`: 平台接口定义
- `MethodChannelPopscopeIos`: MethodChannel 实现，处理来自原生端的事件

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 相关资源

- [Flutter 插件开发文档](https://flutter.dev/docs/development/packages-and-plugins/developing-packages)
- [iOS UIGestureRecognizerDelegate 文档](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate)
- [Flutter MethodChannel 文档](https://api.flutter.dev/flutter/services/MethodChannel-class.html)

