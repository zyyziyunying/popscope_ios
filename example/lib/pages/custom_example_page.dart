import 'package:flutter/material.dart';
import 'package:popscope_ios_example/widgets/step_item.dart';
import 'package:popscope_ios_example/widgets/confirm_pop_dialog.dart';
import 'package:popscope_ios_plus/popscope_ios.dart';

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
  bool _isRegistered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isRegistered) {
      PopscopeIos.registerPopGestureCallback(() {
        setState(() {
          _gestureCount++;
        });
        ConfirmPopDialog.show(context);
      }, context);
      _isRegistered = true;
    }
  }

  @override
  void dispose() {
    if (_isRegistered) {
      PopscopeIos.unregisterPopGestureCallback(context);
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
            const StepItem(number: '1', text: '尝试从左边缘向右滑动', color: Colors.orange),
            const StepItem(number: '2', text: '会弹出确认对话框', color: Colors.orange),
            const StepItem(number: '3', text: '点击确认才会返回', color: Colors.orange),
            const StepItem(number: '4', text: '观察手势计数器的变化', color: Colors.orange),
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
                        '}, context);',
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

}

