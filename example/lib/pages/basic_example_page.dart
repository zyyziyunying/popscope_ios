import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popscope_ios/popscope_ios.dart';

/// 基础示例页面：展示如何使用 setNavigatorKey 自动处理返回手势
class BasicExamplePage extends StatefulWidget {
  const BasicExamplePage({super.key});

  @override
  State<BasicExamplePage> createState() => _BasicExamplePageState();
}

class _BasicExamplePageState extends State<BasicExamplePage> {
  String _platformVersion = 'Unknown';
  int _backGestureCount = 0;
  final _popscopeIosPlugin = PopscopeIos();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setupBackGestureListener();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _popscopeIosPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  /// 设置系统返回手势监听
  ///
  /// 这个方法演示了如何使用 setOnLeftBackGesture 来监听返回手势。
  /// 在这个示例中，我们同时设置了 setNavigatorKey 和 setOnLeftBackGesture，
  /// 所以执行顺序是：
  /// 1. 插件自动调用 Navigator.maybePop()
  /// 2. 执行这里设置的回调函数
  void setupBackGestureListener() {
    // 设置 Navigator Key，启用自动导航处理
    PopscopeIos.setNavigatorKey(_navigatorKey);
    
    // 设置回调监听
    PopscopeIos.setOnLeftBackGesture(() {
      debugPrint('检测到系统返回手势！系统已自动调用 Navigator.maybePop()');

      // 更新计数（用于 UI 显示）
      if (mounted) {
        setState(() {
          _backGestureCount++;
        });
      }
    });
  }

  @override
  void dispose() {
    // 清理设置
    PopscopeIos.setNavigatorKey(null);
    PopscopeIos.setOnLeftBackGesture(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('基础示例')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              const SizedBox(height: 20),
              Text(
                '返回手势触发次数: $_backGestureCount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    _navigatorKey.currentContext!,
                    MaterialPageRoute(builder: (context) => const SecondPage()),
                  );
                },
                child: const Text('打开第二页'),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  '提示：在第二页尝试左滑返回\n系统会自动调用 Navigator.maybePop()',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
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
      appBar: AppBar(title: const Text('第二页')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swipe_left, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              '尝试左滑返回',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '系统返回手势被拦截后\n会自动调用 Navigator.maybePop()',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

