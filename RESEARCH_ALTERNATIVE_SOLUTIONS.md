# 不依赖 NavigationController 的替代方案研究

## 研究背景

当前 `popscope_ios` 插件依赖 `UINavigationController.interactivePopGestureRecognizer` 来拦截左滑返回手势，这导致：
- 需要在运行时可能修改视图层次结构
- 可能与其他插件产生冲突
- 增加了集成复杂度

## 方案一：UIScreenEdgePanGestureRecognizer

### 核心思路
直接在 FlutterViewController 的 view 上添加边缘滑动手势识别器，完全不依赖 NavigationController。

### 实现代码（伪代码）

```swift
public class PopscopeIosPlugin: NSObject, FlutterPlugin {
  private var edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer?
  private weak var flutterViewController: FlutterViewController?
  private var channel: FlutterMethodChannel?

  private func setupEdgeGesture() {
    guard let flutterVC = getFlutterViewController() else { return }

    let edgeGesture = UIScreenEdgePanGestureRecognizer(
      target: self,
      action: #selector(handleEdgeSwipe(_:))
    )
    edgeGesture.edges = .left
    edgeGesture.delegate = self

    flutterVC.view.addGestureRecognizer(edgeGesture)
    self.edgeGestureRecognizer = edgeGesture
  }

  @objc private func handleEdgeSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
    if gesture.state == .began {
      // 通知 Flutter 层
      channel?.invokeMethod("onSystemBackGesture", arguments: nil)
    }
  }
}
```

### 优点
1. ✅ **不修改视图层次结构** - 不需要创建 NavigationController
2. ✅ **实现简单** - 直接添加手势识别器
3. ✅ **兼容性好** - 不会影响其他插件
4. ✅ **可控性强** - 可以自定义手势触发条件（如边缘滑动距离）

### 潜在问题

#### 问题 1：与 Flutter 触摸事件冲突 🔴
**严重程度：高**

Flutter 有自己的触摸事件处理系统（Gesture Arena），可能会：
- 阻止原生手势识别器接收触摸事件
- 导致手势识别不灵敏或失效

**社区已知问题：**
根据 Flutter 官方 issue 跟踪，iOS 平台视图存在触摸事件冲突问题：
- [Issue #27700](https://github.com/flutter/flutter/issues/27700): PlatformView 上的重复触摸事件导致断言失败
- [Issue #24207](https://github.com/flutter/flutter/issues/24207): 使用 UiKitView 时手势识别器错误
- [Issue #48180](https://github.com/flutter/flutter/issues/48180): 某些情况下 PlatformView 需要点击两次才能交互

**解决方案 - 实现同步手势识别：**

```swift
extension PopscopeIosPlugin: UIGestureRecognizerDelegate {
  // ✅ 关键方法：允许与 Flutter 手势同时识别
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true  // 允许同时识别多个手势
  }
}
```

这是 iOS 手势识别的最佳实践：
- 返回 `true` 告诉系统该手势可以与其他手势同时工作
- 确保不会阻塞 Flutter 的手势系统（Gesture Arena）
- 参考：[Apple UIGestureRecognizerDelegate 文档](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate)

**注意事项：**
- FlutterViewController 使用 Hybrid Composition 渲染模式，原生视图会直接添加到视图层次
- 需要确保边缘手势不会与 ListView/GridView 的滑动手势冲突
- 可能需要在 Dart 层配置 `EagerGestureRecognizer` 来处理手势优先级

**验证要点：**
- [x] 需要实现 `gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)` 返回 `true`
- [ ] UIScreenEdgePanGestureRecognizer 能否在 Flutter view 上正常工作
- [ ] 在滑动列表时是否会误触发边缘手势

#### 问题 2：手势行为一致性 ⚠️
**严重程度：中**

系统的 `interactivePopGestureRecognizer` 有很多内置行为：
- 滑动一定距离后才触发返回
- 可以中途取消（松手时根据滑动距离决定是否返回）
- 有动画效果

使用自定义手势识别器需要：
- 手动实现这些逻辑
- 确保行为与系统一致（用户体验）

**解决方案：**
- 监听手势的完整生命周期（began, changed, ended, cancelled）
- 根据滑动距离和速度判断是否应该触发返回
- 提供配置选项（如触发阈值）

#### 问题 3：多页面场景 ⚠️
**严重程度：中**

当前实现使用回调栈机制来处理多页面场景，确保只有最顶层的页面能接收手势。

使用自定义手势识别器时：
- 依然需要回调栈机制（这部分可以复用）
- 需要确保手势只在适当的页面上触发

**解决方案：**
- 复用现有的回调栈机制
- 在 `handleEdgeSwipe` 中添加页面检查逻辑

## 方案二：监听 Flutter 触摸事件

### 核心思路
通过 Platform Channel 让 Flutter 层检测边缘滑动手势，然后回调原生层。

### 优点
- ✅ 完全在 Flutter 层控制
- ✅ 不需要原生手势识别器

### 缺点
- ❌ 无法真正"拦截"系统手势（如果有 NavigationController）
- ❌ Flutter 层手势检测可能不如原生精准
- ❌ 与插件的设计目标不符（插件的目的就是拦截原生手势）

**结论：不推荐此方案**

## 方案三：混合方案（双模式）

### 核心思路
提供两种工作模式：
1. **NavigationController 模式**（当前实现）- 拦截系统手势
2. **Direct 模式**（新增）- 使用自定义手势识别器

### 实现概要

```swift
public enum InterceptMode {
  case navigationController  // 使用系统的 interactivePopGestureRecognizer
  case direct                // 使用自定义 UIScreenEdgePanGestureRecognizer
}

public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  switch call.method {
  case "enableInteractivePopGesture":
    let args = call.arguments as? [String: Any]
    let mode = args?["mode"] as? String ?? "navigationController"

    if mode == "direct" {
      setupEdgeGesture()
    } else {
      setupInteractivePopGestureIfNeeded()
    }
    result(nil)
  }
}
```

### 优点
- ✅ 向后兼容 - 默认使用现有方案
- ✅ 灵活性高 - 用户可以根据场景选择
- ✅ 渐进迁移 - 可以先发布 direct 模式作为实验性功能

### 缺点
- ❌ 代码复杂度增加
- ❌ 需要维护两套实现
- ❌ 文档和示例需要说明两种模式的区别

## 下一步行动

### 优先级 1：验证 UIScreenEdgePanGestureRecognizer 可行性

需要创建一个最小可行原型（MVP）来验证：

```swift
// 在 example 项目中测试
class TestViewController: FlutterViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(test))
    edgeGesture.edges = .left
    view.addGestureRecognizer(edgeGesture)
  }

  @objc func test(_ gesture: UIGestureRecognizer) {
    print("✅ 边缘手势被触发")
  }
}
```

**测试点：**
- [ ] 手势是否能正常触发
- [ ] 是否与 Flutter 手势冲突
- [ ] 在滑动列表时是否会误触发
- [ ] 手势灵敏度是否可接受

### 优先级 2：对比性能和用户体验

如果方案一可行，需要对比：
- 手势触发延迟
- 滑动流畅度
- 与系统手势的行为差异

### 优先级 3：决定最终方案

根据验证结果决定：
- 完全替换为 UIScreenEdgePanGestureRecognizer
- 或实现双模式支持
- 或保持现状但改进文档

## 参考资料

### iOS 手势识别器
- [UIScreenEdgePanGestureRecognizer 官方文档](https://developer.apple.com/documentation/uikit/uiscreenedgepangesturerecognizer)
- [UIGestureRecognizerDelegate 协议](https://developer.apple.com/documentation/uikit/uigesturerecognizerdelegate)
- [UIGestureRecognizer Tutorial: Getting Started](https://www.kodeco.com/6747815-uigesturerecognizer-tutorial-getting-started)

### Flutter 平台视图与手势处理
- [Host native iOS views in your Flutter app with platform views](https://docs.flutter.dev/platform-integration/ios/platform-views)
- [UiKitView gestureRecognizers property](https://api.flutter.dev/flutter/widgets/UiKitView/gestureRecognizers.html)
- [Flutter PlatformView 实现指南](https://medium.com/flutter-community/flutter-platformview-how-to-host-native-android-and-ios-view-in-flutter-79259faebd91)

### 已知问题与解决方案
- [Issue #27700: PlatformView 重复触摸事件](https://github.com/flutter/flutter/issues/27700)
- [Issue #24207: UiKitView 手势识别器错误](https://github.com/flutter/flutter/issues/24207)
- [Issue #48180: PlatformView 交互延迟问题](https://github.com/flutter/flutter/issues/48180)
- [Issue #53490: iOS WebView 手势识别器被阻塞](https://github.com/flutter/flutter/issues/53490)
- [PR #2339: webview_flutter 添加手势导航](https://github.com/flutter/plugins/pull/2339)
