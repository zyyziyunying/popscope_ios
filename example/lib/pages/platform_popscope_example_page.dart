import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popscope_ios/popscope_ios.dart';

/// PlatformPopScope 示例页面
///
/// 推荐使用方式：使用 PlatformPopScope widget，它会自动处理：
/// 1. iOS 平台的手势拦截初始化
/// 2. 组件销毁时的资源清理
/// 3. 跨平台兼容性（iOS 使用手势拦截，其他平台使用标准 PopScope）
class PlatformPopScopeExamplePage extends StatefulWidget {
  const PlatformPopScopeExamplePage({super.key});

  @override
  State<PlatformPopScopeExamplePage> createState() =>
      _PlatformPopScopeExamplePageState();
}

class _PlatformPopScopeExamplePageState
    extends State<PlatformPopScopeExamplePage> {
  String _platformVersion = 'Unknown';
  int _popInvokedCount = 0;
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

  void _handlePop() async {
    setState(() {
      _popInvokedCount++;
    });

    // 显示确认对话框
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('确认返回'),
          content: const Text('检测到返回操作，是否要返回上一页？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
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
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: PlatformPopScope(
        canPop: false,
        onPop: _handlePop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('PlatformPopScope 示例'),
            backgroundColor: Colors.orange,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 推荐标识
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '推荐使用方式',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'PlatformPopScope 会自动处理初始化和销毁，无需手动管理资源',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 状态卡片
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 60,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'PlatformPopScope 状态',
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
                          '返回操作触发次数',
                          '$_popInvokedCount',
                          Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _buildStatusRow('平台', _platformVersion, Colors.blue),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 优势说明
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
                            Icon(
                              Icons.auto_awesome,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PlatformPopScope 的优势',
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
                          '✓ 自动处理资源管理：组件销毁时自动清理回调\n'
                          '✓ 跨平台兼容：iOS 使用手势拦截，其他平台使用标准 PopScope\n'
                          '✓ 简化代码：无需手动调用 setOnLeftBackGesture 和 dispose\n'
                          '✓ 避免内存泄漏：自动管理生命周期',
                          style: TextStyle(fontSize: 14),
                        ),
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
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                            ),
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
                          '3. 观察是否弹出确认对话框\n'
                          '4. 查看返回操作触发次数',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 代码示例
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.code, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text(
                              '使用示例',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PlatformPopScope(\n'
                            '  canPop: false,\n'
                            '  onPop: () {\n'
                            '    // 处理返回逻辑\n'
                            '  },\n'
                            '  child: YourWidget(),\n'
                            ')',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
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
