import 'package:flutter/material.dart';
import 'package:popscope_ios/utils/logger.dart';
import 'package:popscope_ios_example/widgets/step_item.dart';
import 'package:popscope_ios_example/widgets/confirm_pop_dialog.dart';
import 'package:popscope_ios/popscope_ios.dart';

/// 负面示例：使用已废弃的 setOnLeftBackGesture 方法
///
/// 展示使用全局 setOnLeftBackGesture 方法会导致的问题：
/// - 多个页面嵌套时，回调会被覆盖
/// - 页面B设置了回调，页面C也设置了回调，页面C的回调会覆盖页面B的回调
/// - 即使返回页面B，页面B的回调也不会生效，因为已经被页面C的回调覆盖了
class BadExamplePage extends StatelessWidget {
  const BadExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('负面示例：全局回调覆盖问题'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 警告卡片
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '⚠️ 负面示例',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '本页面展示了使用已废弃的 setOnLeftBackGesture 方法会导致的问题。\n\n'
                      '• 页面A -> 页面B -> 页面C\n'
                      '• B页面使用 setOnLeftBackGesture 设置回调\n'
                      '• C页面也使用 setOnLeftBackGesture 设置回调\n'
                      '• C页面的回调会覆盖B页面的回调\n'
                      '• 即使返回B页面，B页面的回调也不会生效\n'
                      '• 全局回调覆盖，导致页面级回调失效',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 对比说明
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.compare_arrows,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '对比说明',
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
                      '❌ 错误做法（本示例）：\n'
                      '使用 setOnLeftBackGesture，全局回调会被覆盖\n\n'
                      '✅ 正确做法：\n'
                      '使用 PlatformPopScope 或 registerPopGestureCallback\n'
                      '每个页面的回调独立管理，互不影响',
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
            const StepItem(number: '1', text: '点击下方按钮进入页面B', color: Colors.red),
            const StepItem(
              number: '2',
              text: '在页面B中，观察：B页面设置了回调',
              color: Colors.red,
            ),
            const StepItem(number: '3', text: '在页面B中进入页面C', color: Colors.red),
            const StepItem(
              number: '4',
              text: '在页面C中，观察：C页面覆盖了B页面的回调',
              color: Colors.red,
            ),
            const StepItem(
              number: '5',
              text: '在页面C中尝试左滑返回，会触发C页面的回调',
              color: Colors.red,
            ),
            const StepItem(
              number: '6',
              text: '返回B页面后，B页面的回调仍然不会生效',
              color: Colors.red,
            ),
            const StepItem(
              number: '7',
              text: '因为C页面的回调已经覆盖了B页面的回调',
              color: Colors.red,
            ),
            const SizedBox(height: 20),

            // 导航按钮
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BadPageB()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('进入页面B（使用 setOnLeftBackGesture）'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 页面B：使用已废弃的 setOnLeftBackGesture 设置回调
class BadPageB extends StatefulWidget {
  const BadPageB({super.key});

  @override
  State<BadPageB> createState() => _BadPageBState();
}

class _BadPageBState extends State<BadPageB> {
  int _callbackInvokedCount = 0;

  @override
  void initState() {
    super.initState();
    // ! 使用已废弃的方法，会导致回调覆盖问题
    PopscopeIos.setOnLeftBackGesture(() {
      setState(() {
        _callbackInvokedCount++;
      });
      ConfirmPopDialog.show(
        context,
        title: '页面B的回调被触发',
        content: '这是页面B的回调，但可能已经被页面C覆盖了',
      );
    });
  }

  @override
  void dispose() {
    // ! 清理回调，避免影响其他页面
    PopscopeIos.setOnLeftBackGesture(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面B（使用 setOnLeftBackGesture）'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态卡片
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.gesture, size: 48, color: Colors.orange),
                    const SizedBox(height: 12),
                    const Text(
                      '本页面使用 setOnLeftBackGesture',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '回调被触发次数: $_callbackInvokedCount',
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
              '• 本页面在 initState 中使用 setOnLeftBackGesture 设置回调\n'
              '• 当触发返回手势时，应该显示确认对话框\n'
              '• 但是如果进入页面C，页面C也会设置回调\n'
              '• 页面C的回调会覆盖本页面的回调\n'
              '• 即使返回本页面，本页面的回调也不会生效',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BadPageC()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('进入页面C（也会设置回调）'),
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

/// 页面C：也使用已废弃的 setOnLeftBackGesture 设置回调
class BadPageC extends StatefulWidget {
  const BadPageC({super.key});

  @override
  State<BadPageC> createState() => _BadPageCState();
}

class _BadPageCState extends State<BadPageC> {
  int _callbackInvokedCount = 0;
  bool _shouldCleanupOnDispose = true; // 是否在dispose时清理回调

  @override
  void initState() {
    super.initState();
    // ! 使用已废弃的方法，会覆盖页面B的回调
    PopscopeIos.setOnLeftBackGesture(() {
      PopscopeLogger.info('页面C的回调被触发');
      setState(() {
        _callbackInvokedCount++;
      });
    });
  }

  @override
  void dispose() {
    // ! 根据开关决定是否清理回调
    if (_shouldCleanupOnDispose) {
      PopscopeIos.setOnLeftBackGesture(null);
    }
    // 如果不清理，页面C的回调会一直存在，即使返回页面B也不会恢复页面B的回调
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面C（覆盖了页面B的回调）'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 说明卡片
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.block, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    const Text(
                      '本页面也使用 setOnLeftBackGesture',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '回调被触发次数: $_callbackInvokedCount',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 清理回调开关
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '是否在退出时清理回调',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _shouldCleanupOnDispose
                                ? '❌ 清理：返回页面B后，全局回调被清空，页面B的回调也不会生效'
                                : '❌ 不清理：返回页面B后，仍然是页面C的回调',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _shouldCleanupOnDispose,
                      onChanged: (value) {
                        setState(() {
                          _shouldCleanupOnDispose = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '问题说明：',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '• 本页面在 initState 中也使用 setOnLeftBackGesture 设置回调\n'
              '• 这会覆盖页面B的回调\n'
              '• 尝试左滑返回时，会触发本页面的回调\n'
              '• ${_shouldCleanupOnDispose ? "如果清理回调" : "如果不清理回调"}，${_shouldCleanupOnDispose ? "返回页面B后，全局回调被清空，页面B的回调也不会生效（因为页面B的回调在页面C进入时就已经被覆盖了）" : "即使返回页面B，仍然是页面C的回调，页面B的回调也不会生效"}\n'
              '• 因为全局回调已经被本页面的回调覆盖了\n'
              '• 这就是全局回调覆盖的问题',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),

            Card(
              color: Colors.yellow.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '这就是全局回调覆盖的问题',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '多个页面使用 setOnLeftBackGesture 时，\n'
                      '后设置的会覆盖先设置的，导致页面级回调失效。\n\n'
                      '应该使用 PlatformPopScope 或 registerPopGestureCallback\n'
                      '来避免这个问题。',
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
