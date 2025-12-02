# popscope_ios

一个用于拦截和处理 iOS 系统左滑返回手势的 Flutter 插件。

## 功能特性

- 🎯 拦截 iOS 系统的左滑返回手势（interactivePopGesture）
- 🤖 支持自动处理页面返回（通过 Navigator）
- 🔧 支持业务自定义处理逻辑
- 📦 轻量级，易于集成

## 为什么需要这个插件？

在 Flutter iOS 应用中，iOS 的左滑手势（Interactive Pop Gesture）是独立于 Flutter Navigator 运行的原生手势。
当这个手势被启动时，如果它发现 PopScope 设置了 canPop: false，它会简单地取消手势并停止，
而不会向 Flutter 的 Navigator 发送一个明确的弹出（Pop）请求。因此，onPopInvokedWithResult 回调自然不会被触发到
当使用 `UINavigationController` 时，系统默认的左滑返回手势（interactivePopGesture）会与 Flutter 的页面导航系统产生冲突。这个插件通过拦截系统手势，让你可以：

1. **自动处理**：插件自动调用 Flutter 的 `Navigator.maybePop()`，实现页面返回
2. **自定义处理**：在返回前执行自定义逻辑，如保存数据、显示确认对话框等

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  popscope_ios: ^1.0.0
```

然后运行：

```bash
flutter pub get
```

## 使用方法

插件提供了两个主要方法，**至少需要设置其中一个**才能使插件生效：

### 方法 1：setNavigatorKey - 自动处理页面返回

如果你希望插件自动处理页面返回，无需业务层介入，使用此方法。

```dart
import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

// 1. 创建全局 Navigator Key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. 设置 Navigator Key，启用自动处理
  PopscopeIos.setNavigatorKey(navigatorKey);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 3. 关联到 MaterialApp
      home: const HomePage(),
    );
  }
}
```

**工作原理：**
- 当用户执行左滑返回手势时，插件会自动调用 `Navigator.maybePop()`
- 如果当前页面可以返回（不是根页面），则执行返回操作
- 如果是根页面，则不做任何操作

### 方法 2：setOnLeftBackGesture - 业务自定义处理

如果你需要在返回前执行自定义逻辑，或者完全自定义返回行为，使用此方法。

```dart
import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 设置左滑返回手势回调
  PopscopeIos.setOnLeftBackGesture(() {
    print('检测到左滑返回手势');
    // 在这里执行自定义逻辑
    // 例如：显示确认对话框、保存数据、统计等
  });
  
  runApp(const MyApp());
}
```

**注意：** 如果只设置 `setOnLeftBackGesture` 而不设置 `setNavigatorKey`，你需要在回调中自行处理页面返回逻辑。

### 方法 3：两者结合使用

你也可以同时使用两个方法，既享受自动返回的便利，又能执行自定义逻辑：

```dart
import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 设置自动处理
  PopscopeIos.setNavigatorKey(navigatorKey);
  
  // 2. 同时设置自定义回调
  PopscopeIos.setOnLeftBackGesture(() {
    print('返回手势触发，系统已自动调用 Navigator.maybePop()');
    // 执行额外的逻辑，如统计、日志记录等
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomePage(),
    );
  }
}
```

**执行顺序：**
1. 检测到左滑手势
2. 插件自动调用 `Navigator.maybePop()`
3. 执行 `setOnLeftBackGesture` 设置的回调函数

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 设置 Navigator Key，启用自动导航处理
  PopscopeIos.setNavigatorKey(navigatorKey);
  
  // 设置返回手势监听
  PopscopeIos.setOnLeftBackGesture(() {
    print('检测到系统返回手势');
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SecondPage(),
              ),
            );
          },
          child: const Text('打开第二页'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第二页'),
      ),
      body: const Center(
        child: Text(
          '尝试左滑返回\n系统会自动调用 Navigator.maybePop()',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
```

## API 文档

### setNavigatorKey

设置 Navigator Key，用于自动处理页面返回。

```dart
static void setNavigatorKey(
  GlobalKey<NavigatorState>? navigatorKey, 
  {bool autoHandle = true}
)
```

**参数：**
- `navigatorKey`: 全局 Navigator Key，通常在 MaterialApp 中设置
- `autoHandle`: 是否自动处理导航，默认为 `true`

**使用场景：**
- 希望插件自动处理页面返回，无需业务层介入
- 需要与 Flutter 的导航系统集成

### setOnLeftBackGesture

设置左滑返回手势的回调函数。

```dart
static void setOnLeftBackGesture(VoidCallback? callback)
```

**参数：**
- `callback`: 手势触发时的回调函数，传入 `null` 可清除回调

**使用场景：**
- 需要在返回前执行自定义逻辑（如保存数据、显示确认对话框等）
- 需要根据业务状态决定是否允许返回
- 需要统计或记录用户的返回行为

**注意：**
- 如果同时设置了 `setNavigatorKey`，会先自动调用 `maybePop()`，然后再执行此回调
- 如果只设置此回调而不设置 `setNavigatorKey`，则需要在回调中自行处理页面返回

## 常见问题

### Q: 必须同时设置两个方法吗？

A: 不需要。至少设置其中一个即可：
- 只设置 `setNavigatorKey`：插件自动处理页面返回
- 只设置 `setOnLeftBackGesture`：业务自定义处理
- 两者都设置：先自动返回，再执行自定义逻辑

### Q: 为什么要在 main() 函数中调用这些方法？

A: 为了确保在应用启动时就完成插件的初始化，这样可以在整个应用生命周期内拦截左滑手势。

### Q: 插件会影响 Android 平台吗？

A: 不会。这个插件仅在 iOS 平台生效，Android 平台会忽略这些调用。

### Q: 如何禁用插件？

A: 调用 `setNavigatorKey(null)` 和 `setOnLeftBackGesture(null)` 即可清除设置。

### Q: 插件如何工作的？

A: 插件通过拦截 iOS 的 `UINavigationController.interactivePopGestureRecognizer` 手势识别器，在手势开始时阻止系统的默认行为，转而通知 Flutter 层处理。

## 技术实现

### iOS 端

插件在 iOS 端通过以下步骤实现手势拦截：

1. 自动创建或获取 `UINavigationController`
2. 设置自定义的 `UIGestureRecognizerDelegate`
3. 在 `gestureRecognizerShouldBegin` 中拦截左滑手势
4. 通过 Method Channel 通知 Flutter 层

### Flutter 端

Flutter 端通过 Method Channel 接收手势事件，然后：

1. 如果设置了 `navigatorKey` 且 `autoHandle` 为 true，自动调用 `Navigator.maybePop()`
2. 如果设置了 `setOnLeftBackGesture` 回调，执行回调函数

## 兼容性

- Flutter: >=3.0.0
- iOS: >=12.0
- Dart: >=3.0.0

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解版本更新信息。
