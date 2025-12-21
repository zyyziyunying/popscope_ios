import 'package:flutter/material.dart';
import 'package:popscope_ios_example/widgets/step_item.dart';
import 'package:popscope_ios/popscope_ios.dart';

/// 多页面嵌套示例
///
/// 展示多个页面嵌套时回调栈的管理
/// 验证只有顶层页面的回调会被调用
class NestedExamplePage extends StatelessWidget {
  const NestedExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('多页面嵌套示例'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 说明卡片
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.teal.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '功能说明',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '本页面展示了多页面嵌套时页面级回调的管理。\n\n'
                      '• 页面A -> 页面B -> 页面C\n'
                      '• B页面使用 registerPopGestureCallback 注册回调\n'
                      '• C页面没有注册回调\n'
                      '• 在C页面触发手势时，不会调用B页面的回调\n'
                      '• 返回B页面后，B页面的回调才会生效\n'
                      '• 页面级回调，互不影响，避免全局覆盖问题',
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
            const StepItem(number: '1', text: '点击下方按钮进入页面B', color: Colors.teal),
            const StepItem(number: '2', text: '在页面B中进入页面C', color: Colors.teal),
            const StepItem(number: '3', text: '在页面C中尝试左滑返回', color: Colors.teal),
            const StepItem(number: '4', text: '观察：不会触发B页面的回调', color: Colors.teal),
            const StepItem(number: '5', text: '返回B页面后，B页面的回调才会生效', color: Colors.teal),
            const SizedBox(height: 20),

            // 导航按钮
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageB()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('进入页面B'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

/// 页面B：注册了回调
class PageB extends StatefulWidget {
  const PageB({super.key});

  @override
  State<PageB> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  int _gestureCount = 0;
  Object? _callbackToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _callbackToken ??= PopscopeIos.registerPopGestureCallback(() {
      setState(() {
        _gestureCount++;
      });
      _showMessage('页面B的回调被触发！');
    }, context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue),
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
        title: const Text('页面B（已注册回调）'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态卡片
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.gesture, size: 48, color: Colors.blue),
                    const SizedBox(height: 12),
                    const Text(
                      '本页面已注册回调',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '手势触发次数: $_gestureCount',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '说明：',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 本页面注册了回调，传递了 context\n'
              '• 只有当本页面在顶层时，回调才会被调用\n'
              '• 如果进入页面C，在C页面触发手势不会调用本页面的回调',
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageC()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('进入页面C（无回调）'),
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

/// 页面C：没有注册回调
class PageC extends StatelessWidget {
  const PageC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面C（无回调）'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 说明卡片
            Card(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.block, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      '本页面没有注册回调',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '测试说明：',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 本页面没有注册回调\n'
              '• 尝试左滑返回时，不会触发页面B的回调\n'
              '• 因为页面B不在顶层，所以回调不会被调用\n'
              '• 返回页面B后，B页面的回调才会生效',
            ),
            const SizedBox(height: 20),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '验证回调栈管理',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '这证明了回调栈管理机制的正确性：'
                      '只有顶层页面的回调才会被调用。',
                      textAlign: TextAlign.center,
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
