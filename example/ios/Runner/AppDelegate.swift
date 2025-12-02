import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // 获取 FlutterViewController
     let flutterViewController = window?.rootViewController as! FlutterViewController
// **关键步骤：创建 UINavigationController 并将 FlutterViewController 作为其根视图控制器**
        var navigationController = UINavigationController(rootViewController: flutterViewController)

        // 设置 window 的根视图控制器为 UINavigationController
        window?.rootViewController = navigationController
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
