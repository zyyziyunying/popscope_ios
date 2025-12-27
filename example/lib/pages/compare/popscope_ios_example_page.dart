import 'package:flutter/material.dart';
import 'package:popscope_ios_plus/popscope_ios.dart';
import 'package:popscope_ios_plus/utils/logger.dart';
import 'package:popscope_ios_example/widgets/step_item.dart';

/// popscope_ios 示例页面
class PopscopeIosExamplePage extends StatefulWidget {
  const PopscopeIosExamplePage({super.key});

  @override
  State<PopscopeIosExamplePage> createState() => _PopscopeIosExamplePageState();
}

class _PopscopeIosExamplePageState extends State<PopscopeIosExamplePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PopscopeIos.registerPopGestureCallback(() {
      PopscopeLogger.info('popscope_ios: registerPopGestureCallback 被触发');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('popscope_ios'),
          content: const Text('确定要返回吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
                Navigator.maybePop(context); // 返回上一页
              },
              child: const Text('确认'),
            ),
          ],
        ),
      );
    }, context);
  }

  @override
  void dispose() {
    PopscopeIos.unregisterPopGestureCallback(context);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('popscope_ios 示例'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '使用方式',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '本页面使用 popscope_ios 库。\n\n'
                      '优势：\n'
                      '• ✅ 直接拦截手势，不滑动，用户体验更好\n'
                      '• ✅ 无需配置，开箱即用\n'
                      '• ✅ 自动管理回调栈，多页面嵌套无压力\n'
                      '• ✅ 自动检查 context，确保只有顶层页面触发\n'
                      '• ✅ 支持 Flutter 3.12+ 的 PopScope 集成\n'
                      '• ✅ 支持多种使用方式，灵活选择',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '测试步骤：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const StepItem(
              number: '1',
              text: '尝试从左边缘向右滑动',
              color: Colors.green,
            ),
            const StepItem(
              number: '2',
              text: '✅ 注意：页面不会滑动，直接拦截手势',
              color: Colors.green,
            ),
            const StepItem(
              number: '3',
              text: '观察是否弹出确认对话框',
              color: Colors.green,
            ),
            const StepItem(number: '4', text: '查看控制台日志输出', color: Colors.green),
            const SizedBox(height: 20),
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
                        '// 在 didChangeDependencies 中注册\n'
                        'PopscopeIos.registerPopGestureCallback(() {\n'
                        '  // 处理逻辑\n'
                        '}, context);\n\n'
                        '// 在 dispose 中注销\n'
                        'PopscopeIos.unregisterPopGestureCallback(token);',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '优势',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• ✅ 直接拦截手势，不滑动，用户体验更好\n'
                      '• ✅ 无需配置，开箱即用\n'
                      '• ✅ 自动管理回调栈，多页面嵌套无压力\n'
                      '• ✅ 自动检查 context，确保只有顶层页面触发\n'
                      '• ✅ 支持 Flutter 3.12+ 的 PopScope 集成\n'
                      '• ✅ 支持多种使用方式，灵活选择',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
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
