import 'package:flutter/material.dart';
import 'package:popscope_ios_example/widgets/step_item.dart';
import 'package:popscope_ios/popscope_ios.dart';

/// 基础示例页面
///
/// 展示页面级回调的基本用法
/// 使用 registerPopGestureCallback 注册回调，自动调用 Navigator.maybePop()
class BasicExamplePage extends StatefulWidget {
  const BasicExamplePage({super.key});

  @override
  State<BasicExamplePage> createState() => _BasicExamplePageState();
}

class _BasicExamplePageState extends State<BasicExamplePage> {
  Object? _callbackToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _callbackToken ??= PopscopeIos.registerPopGestureCallback(() {
      Navigator.maybePop(context);
    }, context);
  }

  @override
  void dispose() {
    /// 组件销毁时注销回调，避免内存泄漏
    if (_callbackToken != null) {
      PopscopeIos.unregisterPopGestureCallback(_callbackToken!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('基础示例'), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 说明卡片
            Card(
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
                          '功能说明',
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
                      '本页面展示了页面级回调的基本用法。\n\n'
                      '• 使用 registerPopGestureCallback 注册回调\n'
                      '• 传递 context，确保只有当前页面在顶层时触发\n'
                      '• 回调中调用 Navigator.maybePop() 实现自动返回\n'
                      '• 页面级回调，不影响其他页面',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 测试说明
            const Text(
              '测试步骤：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const StepItem(number: '1', text: '尝试从左边缘向右滑动', color: Colors.blue),
            const StepItem(number: '2', text: '观察页面是否自动返回', color: Colors.blue),
            const StepItem(number: '3', text: '查看控制台日志输出', color: Colors.blue),
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
                        '  Navigator.maybePop(context);\n'
                        '}, context);',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 导航按钮
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('进入第二页测试'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 第二页，用于测试返回功能
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('第二页'), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              '尝试左滑返回',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '系统会自动调用 Navigator.maybePop()',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('点击返回'),
            ),
          ],
        ),
      ),
    );
  }
}
