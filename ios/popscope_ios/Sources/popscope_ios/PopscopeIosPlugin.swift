import Flutter
import UIKit

public class PopscopeIosPlugin: NSObject, FlutterPlugin, UIGestureRecognizerDelegate {
  private weak var navigationController: UINavigationController?
  private var originalDelegate: UIGestureRecognizerDelegate?
  private var channel: FlutterMethodChannel?
  private var isSetup = false
  
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
//     guard !isSetup else { return }
//
//     // 获取根控制器（兼容不同 iOS 版本）
//     var rootViewController: UIViewController?
//
//     if #available(iOS 13.0, *) {
//       // iOS 13+ 使用 UIWindowScene
//       if let windowScene = UIApplication.shared.connectedScenes
//         .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//         rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
//           ?? windowScene.windows.first?.rootViewController
//       }
//     }
//
//     // 回退方案：遍历所有 windows
//     if rootViewController == nil {
//       rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
//         ?? UIApplication.shared.windows.first?.rootViewController
//     }
//
//     guard let viewController = rootViewController else {
//       print("PopscopeIosPlugin: Root view controller not found, will retry...")
//       // 如果还没准备好，再次尝试
//       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//         self?.setupInteractivePopGestureIfNeeded()
//       }
//       return
//     }
//
//     isSetup = true
  guard let window = UIApplication.shared.windows.first,
         let rootViewController = window.rootViewController else {
         print("PopscopeIosPlugin: window1")
                return
            }

        if let navController = rootViewController as? UINavigationController {
                self.navigationController = navController
                print("PopscopeIosPlugin: window2222")
         } else if let flutterVC = rootViewController as? FlutterViewController {
                self.navigationController = flutterVC.navigationController
                print("PopscopeIosPlugin: window33333")
         }
    setupInteractivePopGesture()
  }
  
  private func setupInteractivePopGesture() {
    // 查找 UINavigationController
//     var navController: UINavigationController?
//
//     if let nav = viewController as? UINavigationController {
//       navController = nav
//     } else if let nav = viewController.navigationController {
//       navController = nav
//     } else {
//       // 遍历子控制器查找 UINavigationController
//       for child in viewController.children {
//         if let nav = child as? UINavigationController {
//           navController = nav
//           break
//         }
//       }
//     }
//
//     guard let navController = navController else {
//       print("PopscopeIosPlugin: UINavigationController not found")
//       return
//     }
//
//     self.navigationController = navController
    
    // 保存原始的代理
    self.originalDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
    
    // 设置自己为代理
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    
    print("PopscopeIosPlugin: Successfully set interactivePopGestureRecognizer delegate")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // 确保手势已设置
//     if !isSetup {
//       setupInteractivePopGestureIfNeeded()
//     }
    
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "setup":
      // 手动触发设置
      setupInteractivePopGestureIfNeeded()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // MARK: - UIGestureRecognizerDelegate
  
  // 控制是否允许手势开始
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//     // 默认行为：当导航栈中有多个控制器时允许返回手势
//     guard let navController = navigationController else {
//       return true
//     }
//
//     // 确保不是根控制器
//     if navController.viewControllers.count <= 1 {
//       return false
//     }
    
    // 检测到系统左滑手势，发送事件给 Flutter
    if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
      channel?.invokeMethod("onSystemBackGesture", arguments: nil)
       print("PopscopeIosPlugin: onSystemBackGesture call")
      return false
    }
    
    return true
  }
  
  // 允许同时识别多个手势
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
