import Flutter
import UIKit

/// iOS 左滑返回手势拦截插件
///
/// 该插件通过拦截 UINavigationController 的 interactivePopGestureRecognizer，
/// 在检测到左滑返回手势时通知 Flutter 层进行处理。
public class PopscopeIosPlugin: NSObject, FlutterPlugin, UIGestureRecognizerDelegate {
  /// 弱引用的 Navigation Controller
  private weak var navigationController: UINavigationController?
  
  /// 原始的手势识别器代理，用于保留系统默认行为
  private var originalDelegate: UIGestureRecognizerDelegate?
  
  /// 与 Flutter 通信的 Method Channel
  private var channel: FlutterMethodChannel?
  
  /// 插件注册入口
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "popscope_ios", binaryMessenger: registrar.messenger())
    let instance = PopscopeIosPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // 延迟设置，确保 Flutter UI 已经初始化
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      instance.setupInteractivePopGestureIfNeeded()
    }
  }
  
  /// 如果需要，设置左滑返回手势拦截
  ///
  /// 该方法会检查 rootViewController 的类型：
  /// - 如果是 UINavigationController，直接使用
  /// - 如果是 FlutterViewController，会创建或使用现有的 NavigationController
  private func setupInteractivePopGestureIfNeeded() {
  guard let window = UIApplication.shared.windows.first,
         let rootViewController = window.rootViewController else {
                return
            }

        if let navController = rootViewController as? UINavigationController {
                // 直接使用现有的 NavigationController
                self.navigationController = navController
         } else if let flutterVC = rootViewController as? FlutterViewController {
                // 如果 FlutterViewController 已经有 navigationController，直接使用
                if let existingNavController = flutterVC.navigationController {
                    self.navigationController = existingNavController
                } else {
                    // 否则创建新的 NavigationController 并封装 FlutterViewController
                    // 先将 window.rootViewController 设置为 nil，避免视图层次冲突
                    window.rootViewController = nil
                    let newNavController = UINavigationController(rootViewController: flutterVC)
                    // 隐藏导航栏，避免占据上方空间
                    newNavController.isNavigationBarHidden = true
                    self.navigationController = newNavController
                    // 再设置新的 NavigationController 为 rootViewController
                    window.rootViewController = newNavController
                }
         }
    setupInteractivePopGesture()
  }
  
  /// 设置左滑返回手势的拦截
  ///
  /// 保存原始的手势识别器代理，然后将自己设置为新的代理，以便拦截手势事件
  private func setupInteractivePopGesture() {
    // 保存原始的代理
    self.originalDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
    
    // 设置自己为代理
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // MARK: - UIGestureRecognizerDelegate
  
  /// 控制手势识别器是否应该开始识别手势
  ///
  /// 当检测到左滑返回手势时，会通知 Flutter 层处理，并返回 false 阻止系统默认行为
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
