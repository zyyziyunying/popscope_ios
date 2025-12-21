import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';

/// 自定义处理示例页面
///
/// 展示如何使用自定义回调处理返回手势
/// 可以在返回前执行自定义逻辑，如显示确认对话框
class CustomExamplePage extends StatefulWidget {
  const CustomExamplePage({super.key});

  @override
  State<CustomExamplePage> createState() => _CustomExamplePageState();
}

class _CustomExamplePageState extends State<CustomExamplePage> {
  int _gestureCount = 0;
  Object? _callbackToken;

  @override
  void initState() {
    super.initState();
    _setupCustomCallback();
  }

  void _setupCustomCallback() {
    /// 注册自定义回调
    /// 注意：这里没有传递 context，所以会使用旧版 API 的行为
    /// 在实际使用中，建议使用 IosPopInterceptor 组件
    _callbackToken = PopscopeIos.registerPopGestureCallback(() {
      setState(() {
        _gestureCount++;
      });
      _showConfirmDialog();
    });
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认返回'),
        content: const Text('检测到左滑返回手势，是否确认返回？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
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
  void dispose() {
    if (_callbackToken != null) {
      PopscopeIos.unregisterPopGestureCallback(_callbackToken!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义处理示例'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 说明卡片
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '功能说明',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '本页面展示了自定义处理返回手势的用法。\n\n'
                      '• 注册自定义回调函数\n'
                      '• 在回调中显示确认对话框\n'
                      '• 用户确认后才执行返回操作',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 统计卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.gesture, size: 32, color: Colors.orange),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '手势触发次数',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '$_gestureCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
            _buildStepItem('1', '尝试从左边缘向右滑动'),
            _buildStepItem('2', '会弹出确认对话框'),
            _buildStepItem('3', '点击确认才会返回'),
            _buildStepItem('4', '观察手势计数器的变化'),
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
                        'PopscopeIos.registerPopGestureCallback(() {\n'
                        '  // 显示确认对话框\n'
                        '  showDialog(...);\n'
                        '});',
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
              color: Colors.orange,
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

