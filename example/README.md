# Popscope iOS 示例应用

本目录包含多个示例，展示 `popscope_ios` 插件的不同使用方式。

## 示例列表

### 1. main.dart - 自动处理示例（推荐）⭐️

**运行方式：**
```bash
flutter run
```

**功能展示：**
- ✅ 使用 `GlobalKey<NavigatorState>` 自动处理导航
- ✅ iOS 侧滑手势自动调用 `Navigator.maybePop()`
- ✅ 简单易用，适合大多数场景

**关键代码：**
```dart
final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();  // 必须先初始化
  
  final plugin = PopscopeIos();
  plugin.setNavigatorKey(navigatorKey);  // 启用自动处理
  runApp(MaterialApp(navigatorKey: navigatorKey, ...));
}
```

---

### 2. main_custom.dart - 自定义处理示例

**运行方式：**
```bash
flutter run lib/main_custom.dart
```

**功能展示：**
- ✅ 禁用自动导航处理
- ✅ 显示自定义确认对话框
- ✅ 完全控制返回逻辑
- ✅ 适合需要复杂返回逻辑的场景

**关键代码：**
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();  // 必须先初始化
  
  final plugin = PopscopeIos();
  plugin.setNavigatorKey(navigatorKey, autoHandle: false);  // 禁用自动处理
  
  plugin.setOnSystemBackGesture(() {
    // 自定义处理：显示确认对话框
    showDialog(...);
  });
  
  runApp(MaterialApp(navigatorKey: navigatorKey, ...));
}
```

---

### 3. main_popscope.dart - PopScope Widget 集成示例 🎯

**运行方式：**
```bash
flutter run lib/main_popscope.dart
```

**功能展示：**
- ✅ 使用 Flutter 3.12+ 的 `PopScope` widget
- ✅ 设置 `canPop: false` 阻止直接返回
- ✅ 监听 `onPopInvoked` 回调
- ✅ 展示完整的事件流程和日志
- ✅ 适合需要精细控制返回行为的场景

**工作流程：**
```
用户左滑 → 插件拦截 → 调用 maybePop() 
         → PopScope 检测到 canPop=false 
         → 触发 onPopInvoked(false)
         → 显示确认对话框
```

**关键代码：**
```dart
PopScope(
  canPop: false,  // 阻止直接返回
  onPopInvoked: (bool didPop) {
    if (!didPop) {
      // 显示确认对话框或执行其他逻辑
      showDialog(...);
    }
  },
  child: Scaffold(...),
)
```

**测试说明：**
1. 进入测试页面
2. 尝试点击返回按钮 → 观察 `onPopInvoked(false)` 被触发
3. 尝试 iOS 左滑返回 → 观察整个事件链
4. 查看日志了解详细的事件流程

---

## 对比总结

| 示例 | 使用场景 | 复杂度 | 推荐度 |
|------|---------|--------|--------|
| main.dart | 简单的自动返回 | ⭐ | ⭐⭐⭐⭐⭐ |
| main_custom.dart | 需要确认对话框 | ⭐⭐ | ⭐⭐⭐⭐ |
| main_popscope.dart | 复杂返回逻辑 + Flutter 3.12+ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## 技术细节

### 事件流程

#### 方式 1：自动处理
```
iOS 侧滑手势
    ↓
插件拦截 (gestureRecognizerShouldBegin)
    ↓
发送 MethodChannel 事件
    ↓
Flutter 端接收
    ↓
自动调用 Navigator.maybePop()
    ↓
返回上一页 ✓
```

#### 方式 2：自定义处理
```
iOS 侧滑手势
    ↓
插件拦截
    ↓
发送 MethodChannel 事件
    ↓
Flutter 端接收
    ↓
调用自定义回调
    ↓
显示确认对话框
    ↓
用户确认后返回 ✓
```

#### 方式 3：PopScope 集成
```
iOS 侧滑手势
    ↓
插件拦截
    ↓
发送 MethodChannel 事件
    ↓
Flutter 端接收
    ↓
自动调用 Navigator.maybePop()
    ↓
PopScope 检测到 canPop=false
    ↓
触发 onPopInvoked(false)
    ↓
用户处理返回逻辑 ✓
```

## 运行要求

- Flutter 3.0+ (main.dart, main_custom.dart)
- Flutter 3.12+ (main_popscope.dart，使用 PopScope widget)
- iOS 11.0+
- Xcode 13.0+

## 常见问题

### Q: 为什么会出现 "Cannot set the method call handler before the binary messenger has been initialized" 错误？

A: 这是因为在 `main()` 函数中使用插件前，没有先调用 `WidgetsFlutterBinding.ensureInitialized()`。

**解决方法：**
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();  // 添加这一行
  
  final plugin = PopscopeIos();
  plugin.setNavigatorKey(navigatorKey);
  runApp(MyApp());
}
```

### Q: PopScope 的 onPopInvoked 什么时候被调用？

A: 当以下任一情况发生时：
1. 用户点击返回按钮
2. 调用 `Navigator.maybePop()` 或 `Navigator.pop()`
3. iOS 侧滑手势（通过我们的插件拦截并调用 maybePop）

### Q: canPop 为 false 时会发生什么？

A: 
- 返回操作会被阻止（不会真正返回）
- `onPopInvoked` 会被调用，参数 `didPop` 为 `false`
- 你可以在回调中决定是否真的要返回

### Q: 为什么要使用 PopScope？

A:
- 更符合 Flutter 的设计理念
- 统一处理所有返回事件（按钮、手势、系统返回键等）
- 更好的测试性和可维护性

## 更多信息

查看主项目 README：[../README.md](../README.md)
