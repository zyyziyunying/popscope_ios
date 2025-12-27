import Flutter
import UIKit

/// iOS 左滑返回手势拦截插件
///
/// 该插件通过拦截 UINavigationController 的 interactivePopGestureRecognizer，
/// 在检测到左滑返回手势时通知 Flutter 层进行处理。
public class PopscopeIosPlugin: NSObject, FlutterPlugin, UIGestureRecognizerDelegate {
  /// 弱引用的 Navigation Controller
  ///
  /// 用于访问 interactivePopGestureRecognizer 来拦截左滑返回手势
  /// 使用 weak 引用避免循环引用
  private weak var navigationController: UINavigationController?
  
  /// 原始的手势识别器代理，用于保留系统默认行为
  ///
  /// 当拦截左滑手势时，其他手势（如右滑、点击等）仍交由原始代理处理，
  /// 确保不影响其他手势识别器的正常工作
  private var originalDelegate: UIGestureRecognizerDelegate?
  
  /// 与 Flutter 通信的 Method Channel
  ///
  /// 用于向 Flutter 层发送手势事件通知（onSystemBackGesture）
  private var channel: FlutterMethodChannel?
  
  /// 插件注册入口
  ///
  /// Flutter 插件系统会在应用启动时自动调用此方法
  ///
  /// - Parameter registrar: Flutter 插件注册器，用于注册 Method Channel
  ///
  /// 注意：此方法只创建 Method Channel，不会自动启用手势拦截。
  /// 需要 Flutter 层主动调用 enableInteractivePopGesture 才会启用。
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "popscope_ios_plus", binaryMessenger: registrar.messenger())
    let instance = PopscopeIosPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
    // ! 不再自动设置手势拦截，需要 Flutter 层主动调用 enableInteractivePopGesture 才会启用
  }
  
  /// 如果需要，设置左滑返回手势拦截
  ///
  /// 该方法会检查 rootViewController 的类型，并获取或创建 UINavigationController：
  ///
  /// **情况1：rootViewController 是 UINavigationController**
  /// - 直接使用现有的 NavigationController（最安全，不修改视图层次结构）
  ///
  /// **情况2：rootViewController 是 FlutterViewController**
  /// - 2a：如果 FlutterViewController 已经被包装在 NavigationController 中，直接使用
  /// - 2b：如果没有 NavigationController，创建新的并包装 FlutterViewController
  ///
  /// 注意：情况2b 会在运行时替换 rootViewController，可能导致视图层次结构问题。
  /// 建议在 AppDelegate 中预先配置 UINavigationController。
  private func setupInteractivePopGestureIfNeeded() {
    // 获取应用的窗口和根视图控制器
    guard let window = UIApplication.shared.windows.first,
          let rootViewController = window.rootViewController else {
      // 无法获取 rootViewController，无法设置手势拦截
      return
    }

    if let navController = rootViewController as? UINavigationController {
      // 情况1：rootViewController 本身就是 UINavigationController
      // 直接使用，不需要修改视图层次结构（最安全的方式）
      self.navigationController = navController
    } else if let flutterVC = rootViewController as? FlutterViewController {
      // 情况2：rootViewController 是 FlutterViewController
      if let existingNavController = flutterVC.navigationController {
        // 2a：FlutterViewController 已经被包装在 NavigationController 中
        // 直接使用现有的 NavigationController（安全）
        self.navigationController = existingNavController
      } else {
        // 2b：FlutterViewController 没有 NavigationController
        // 需要创建新的 NavigationController 来包装 FlutterViewController
        // 这样才能访问 interactivePopGestureRecognizer
        
        // 先将 window.rootViewController 设置为 nil，避免视图层次冲突
        window.rootViewController = nil
        
        // 创建新的 NavigationController，以 FlutterViewController 作为根视图控制器
        let newNavController = UINavigationController(rootViewController: flutterVC)
        
        // 隐藏导航栏，避免占据上方空间（Flutter 有自己的导航栏）
        newNavController.isNavigationBarHidden = true
        
        // 保存引用，用于后续拦截手势
        self.navigationController = newNavController
        
        // 将新创建的 NavigationController 设置为 rootViewController
        window.rootViewController = newNavController
      }
    }
    
    // 获取到 NavigationController 后，设置手势拦截
    setupInteractivePopGesture()
  }
  
  /// 设置左滑返回手势的拦截
  ///
  /// 通过实现 UIGestureRecognizerDelegate 协议并设置为代理，
  /// 可以在手势识别器开始识别手势时进行拦截。
  ///
  /// 工作流程：
  /// 1. 保存原始的手势识别器代理（用于处理其他手势）
  /// 2. 将自己设置为新的代理（用于拦截左滑返回手势）
  /// 3. 当手势触发时，gestureRecognizerShouldBegin 会被调用
  private func setupInteractivePopGesture() {
    // 保存原始的代理，用于处理非左滑返回的其他手势
    // 这样可以保持与其他手势识别器的兼容性
    self.originalDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
    
    // 将自己设置为新的代理，这样当左滑手势触发时，
    // gestureRecognizerShouldBegin 方法会被调用，可以进行拦截
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
  }

  /// 处理来自 Flutter 层的方法调用
  ///
  /// 这是 FlutterPlugin 协议要求实现的方法，用于处理 Method Channel 的方法调用
  ///
  /// - Parameters:
  ///   - call: Flutter 层调用的方法信息（包含方法名和参数）
  ///   - result: 返回结果给 Flutter 层的回调
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "enableInteractivePopGesture":
      // Flutter 层主动调用此方法来启用手势拦截
      // 必须在主线程执行，因为涉及 UI 操作（修改 rootViewController）
      DispatchQueue.main.async {
        self.setupInteractivePopGestureIfNeeded()
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // MARK: - UIGestureRecognizerDelegate
  
  /// 控制手势识别器是否应该开始识别手势
  ///
  /// 这是 UIGestureRecognizerDelegate 协议的核心方法，在手势识别器准备开始识别手势时调用。
  ///
  /// **拦截左滑返回手势的流程：**
  /// 1. 用户执行左滑手势
  /// 2. UINavigationController 的 interactivePopGestureRecognizer 检测到手势
  /// 3. 调用此方法（因为我们设置了代理）
  /// 4. 判断是否是左滑返回手势
  /// 5. 如果是，通知 Flutter 层并返回 false（阻止系统默认返回）
  /// 6. 如果不是，交由原始代理处理（保持其他手势的正常行为）
  ///
  /// - Parameter gestureRecognizer: 准备开始识别的手势识别器
  /// - Returns: true 表示允许手势识别，false 表示阻止手势识别
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    // 检测到系统左滑手势，发送事件给 Flutter
    if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
      channel?.invokeMethod("onSystemBackGesture", arguments: nil)
      // 返回 false 阻止系统默认的返回行为，由 Flutter 层处理
      return false
    }
    
    // 其他手势交由原来的代理处理
    if let originalDelegate = self.originalDelegate {
      return originalDelegate.gestureRecognizerShouldBegin?(gestureRecognizer) ?? true
    }
    
    return true
  }
  
  /// 允许同时识别多个手势
  ///
  /// 这样可以确保插件不会影响其他手势识别器的正常工作
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
