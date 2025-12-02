import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:popscope_ios/popscope_ios.dart';

// 创建全局 Navigator Key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// PopScope 示例：展示如何使用 PopScope(canPop: false) 配合 onPopInvoked
/// 
/// 这个示例展示了：
/// 1. 使用 PopScope widget 控制返回行为
/// 2. 监听 onPopInvoked 方法是否被调用
/// 3. 配合 iOS 侧滑手势的拦截
void main() {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  final plugin = PopscopeIos();
  
  // // 设置 Navigator Key，启用自动导航处理
  // plugin.setNavigatorKey(navigatorKey);
  
  // 添加自定义回调来记录事件（可选）
  PopscopeIos.setOnLeftBackGesture(() {
    debugPrint('🔙 iOS 侧滑手势被触发！系统已自动调用 Navigator.maybePop()');
  });
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          await _popscopeIosPlugin.getPlatformVersion() ?? 'Unknown platform version';
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
      // navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.science, size: 80, color: Colors.blue),
            const SizedBox(height: 30),
            const Text(
              'PopScope Widget 测试',
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '进入测试页面后：\n'
                '1. 尝试点击返回按钮\n'
                '2. 尝试左滑返回\n'
                '观察 onPopInvoked 是否被调用',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 使用 PopScope 的测试页面
class PopScopeTestPage extends StatefulWidget {
  const PopScopeTestPage({super.key});

  @override
  State<PopScopeTestPage> createState() => _PopScopeTestPageState();
}

class _PopScopeTestPageState extends State<PopScopeTestPage> {
  int _popInvokedCount = 0;
  String _lastPopType = '未触发';
  final List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toString().substring(11, 19)}: $message');
      if (_logs.length > 10) {
        _logs.removeLast();
      }
    });
  }

  void _handlePopInvoked(bool didPop) {
    _addLog('onPopInvoked 被调用 - didPop: $didPop');
    
    setState(() {
      _popInvokedCount++;
      _lastPopType = didPop ? '已弹出' : '未弹出';
    });

    // 如果没有弹出，显示确认对话框
    if (!didPop) {
      _showConfirmDialog();
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('确认返回'),
          content: const Text('检测到返回操作，是否要返回上一页？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _addLog('用户取消返回');
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                _addLog('用户确认返回');
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 阻止直接返回
      onPopInvokedWithResult: (didPop, _) {
        _handlePopInvoked(didPop);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PopScope 测试页面'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 状态卡片
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.analytics, size: 60, color: Colors.blue),
                      const SizedBox(height: 20),
                      const Text(
                        'PopScope 状态',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      _buildStatusRow('canPop', 'false', Colors.red),
                      const SizedBox(height: 8),
                      _buildStatusRow(
                        'onPopInvoked 调用次数',
                        '$_popInvokedCount',
                        Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _buildStatusRow('最后一次状态', _lastPopType, Colors.orange),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 测试说明
              Card(
                elevation: 2,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            '测试说明',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '1. 点击左上角的返回按钮\n'
                        '2. 使用 iOS 左滑返回手势\n'
                        '3. 观察 onPopInvoked 是否被调用\n'
                        '4. 查看日志了解详细信息',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 日志区域
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.list_alt, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                '事件日志',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (_logs.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _logs.clear();
                                  _popInvokedCount = 0;
                                  _lastPopType = '未触发';
                                });
                              },
                              icon: const Icon(Icons.clear_all, size: 18),
                              label: const Text('清空'),
                            ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      if (_logs.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              '暂无日志',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ..._logs.map((log) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      log,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 预期行为说明
              Card(
                elevation: 2,
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            '预期行为',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '✓ 点击返回按钮：触发 onPopInvoked(false)\n'
                        '✓ iOS 左滑手势：被插件拦截，自动调用 maybePop()\n'
                        '✓ maybePop() 检测到 canPop=false：触发 onPopInvoked(false)\n'
                        '✓ 显示确认对话框，由用户决定是否返回',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

