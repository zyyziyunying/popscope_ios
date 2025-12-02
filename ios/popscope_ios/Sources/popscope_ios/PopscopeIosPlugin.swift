import Flutter
import UIKit

public class PopscopeIosPlugin: NSObject, FlutterPlugin, UIGestureRecognizerDelegate {
  private weak var navigationController: UINavigationController?
  private var originalDelegate: UIGestureRecognizerDelegate?
  private var channel: FlutterMethodChannel?
  
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
  
  private func setupInteractivePopGestureIfNeeded() {
  guard let window = UIApplication.shared.windows.first,
         let rootViewController = window.rootViewController else {
                return
            }

        if let navController = rootViewController as? UINavigationController {
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
                    self.navigationController = newNavController
                    // 再设置新的 NavigationController 为 rootViewController
                    window.rootViewController = newNavController
                }
         }
    setupInteractivePopGesture()
  }
  
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
  
  // 控制是否允许手势开始
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    // 检测到系统左滑手势，发送事件给 Flutter
    if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
      channel?.invokeMethod("onSystemBackGesture", arguments: nil)
      return false
    }
    
    // 其他手势交由原来的代理处理
    if let originalDelegate = self.originalDelegate {
      return originalDelegate.gestureRecognizerShouldBegin?(gestureRecognizer) ?? true
    }
    
    return true
  }
  
  // 允许同时识别多个手势
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
