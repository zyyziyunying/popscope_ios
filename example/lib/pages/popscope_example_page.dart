import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popscope_ios/popscope_ios.dart';
import 'package:popscope_ios_example/pages/pop_scope_test_page.dart';

/// PopScope 示例：展示如何使用 PlatformPopScope（推荐方式）
///
/// 这个示例展示了：
/// 1. 使用 PlatformPopScope widget 控制返回行为（推荐）
/// 2. PlatformPopScope 自动处理资源管理和跨平台兼容性
/// 3. 无需手动管理 setOnLeftBackGesture 的回调
class PopScopeExamplePage extends StatefulWidget {
  const PopScopeExamplePage({super.key});

  @override
  State<PopScopeExamplePage> createState() => _PopScopeExamplePageState();
}

class _PopScopeExamplePageState extends State<PopScopeExamplePage> {
  String _platformVersion = 'Unknown';
  final _popscopeIosPlugin = PopscopeIos();

  @override
  void initState() {
    super.initState();
    initPlatformState();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HomePage(platformVersion: _platformVersion),
    );
  }
}

/// 首页 Widget
class HomePage extends StatelessWidget {
  final String platformVersion;

  const HomePage({super.key, required this.platformVersion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopScope 示例'),
        backgroundColor: Colors.blue,
      ),
      body: PlatformPopScope(
        canPop: false,
        onPop: () {
          // 当返回被阻止时调用
          Navigator.pop(context);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.science, size: 80, color: Colors.blue),
              const SizedBox(height: 30),
              const Text(
                'PlatformPopScope Widget 测试',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Running on: $platformVersion',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PopScopeTestPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('测试 PopScope'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  '进入测试页面后：\n'
                  '1. 尝试点击返回按钮\n'
                  '2. 尝试左滑返回\n'
                  '观察 onPop 是否被调用\n'
                  'PlatformPopScope 会自动处理资源管理',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
