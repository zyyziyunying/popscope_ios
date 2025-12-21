import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popscope_ios/popscope_ios.dart';
import 'package:popscope_ios_example/pages/detail_page.dart';

/// 自定义处理示例：禁用自动导航，手动控制返回行为
///
/// 这个示例展示了如何在检测到返回手势时显示确认对话框
class CustomGesturePage extends StatefulWidget {
  const CustomGesturePage({super.key});

  @override
  State<CustomGesturePage> createState() => _CustomGesturePageState();
}

class _CustomGesturePageState extends State<CustomGesturePage> {
  String _platformVersion = 'Unknown';
  final _popscopeIosPlugin = PopscopeIos();
  bool _gestureEnabled = false; // 手势启用状态
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    // 清理回调
    PopscopeIos.setOnLeftBackGesture(null);
    super.dispose();
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

  /// 切换手势启用状态
  void _toggleGesture() {
    setState(() {
      _gestureEnabled = !_gestureEnabled;
    });

    if (_gestureEnabled) {
      // 启用手势处理
      PopscopeIos.setOnLeftBackGesture(() {
        final context = _navigatorKey.currentContext;
        if (context != null && Navigator.of(context).canPop()) {
          // 显示确认对话框
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('确认返回'),
                content: const Text('您确定要返回上一页吗？'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // 关闭对话框
                    },
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // 关闭对话框
                      Navigator.of(context).pop(); // 返回上一页
                    },
                    child: const Text('确认'),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      // 禁用手势处理
      PopscopeIos.setOnLeftBackGesture(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('自定义处理示例')),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 80, color: Colors.purple),
                  const SizedBox(height: 30),
                  const Text(
                    '自定义返回处理模式',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text('Running on: $_platformVersion'),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DetailPage()),
                      );
                    },
                    child: const Text('打开详情页'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleGesture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _gestureEnabled ? Colors.green : Colors.grey,
                    ),
                    child: Text(
                      _gestureEnabled ? '禁用手势处理' : '启用手势处理',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _gestureEnabled
                          ? '手势处理已启用\n在详情页尝试左滑返回将会弹出确认对话框'
                          : '手势处理已禁用\n在详情页左滑返回将使用系统默认行为',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

