import 'package:flutter/material.dart';
import 'package:popscope_ios/widgets/platform_popscope.dart';

/// PopScope 集成示例页面
///
/// 展示如何与 Flutter 3.12+ 的 PopScope widget 集成
/// 使用 PlatformPopScope 实现跨平台兼容
class PopscopeExamplePage extends StatefulWidget {
  const PopscopeExamplePage({super.key});

  @override
  State<PopscopeExamplePage> createState() => _PopscopeExamplePageState();
}

class _PopscopeExamplePageState extends State<PopscopeExamplePage> {
  bool _canPop = false;
  int _popInvokedCount = 0;
  String _lastPopResult = '无';

  void _handlePop() {
    setState(() {
      _popInvokedCount++;
      _lastPopResult = 'onPopInvoked 被触发';
    });

    /// 显示确认对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认返回'),
        content: const Text('当前页面设置了 canPop: false，是否确认返回？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _canPop = true;
              });
              Navigator.pop(context); // 关闭对话框
              Navigator.pop(context); // 返回上一页
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformPopScope(
      canPop: _canPop,
      onPop: _handlePop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PopScope 集成示例'),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 说明卡片
              Card(
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.purple.shade700),
                          const SizedBox(width: 8),
                          Text(
                            '功能说明',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '本页面展示了与 PopScope widget 的集成。\n\n'
                        '• 使用 PlatformPopScope 实现跨平台兼容\n'
                        '• 设置 canPop: false 阻止直接返回\n'
                        '• iOS 左滑手势会触发 onPopInvoked\n'
                        '• 显示确认对话框后用户确认才返回',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 状态卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildStatItem(
                        'canPop 状态',
                        _canPop ? '允许返回' : '禁止返回',
                        _canPop ? Colors.green : Colors.red,
                      ),
                      const Divider(),
                      _buildStatItem(
                        'onPopInvoked 触发次数',
                        '$_popInvokedCount',
                        Colors.purple,
                      ),
                      const Divider(),
                      _buildStatItem(
                        '最后触发结果',
                        _lastPopResult,
                        Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 测试说明
              const Text(
                '测试步骤：',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildStepItem('1', '尝试点击返回按钮'),
              _buildStepItem('2', '尝试从左边缘向右滑动'),
              _buildStepItem('3', '观察都会触发 onPopInvoked'),
              _buildStepItem('4', '确认后才会真正返回'),
              const SizedBox(height: 20),

              // 代码示例
              Card(
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '关键代码：',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'PlatformPopScope(\n'
                          '  canPop: false,\n'
                          '  onPop: () {\n'
                          '    // 显示确认对话框\n'
                          '  },\n'
                          '  child: Scaffold(...),\n'
                          ')',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
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
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

