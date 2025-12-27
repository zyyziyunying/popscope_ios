import 'package:flutter/material.dart';
import 'package:popscope_ios_plus/utils/logger.dart';
import 'package:popscope_ios_plus_example/widgets/step_item.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';

/// cupertino_will_pop_scope 示例页面
class CupertinoWillPopScopeExamplePage extends StatelessWidget {
  const CupertinoWillPopScopeExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      shouldAddCallback: true,
      onWillPop: () async {
        PopscopeLogger.info('cupertino_will_pop_scope: onWillPop 被触发');
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('cupertino_will_pop_scope'),
            content: const Text('确定要返回吗？'),
            actions: [
              TextButton(
                onPressed: () {
                  PopscopeLogger.info('cupertino_will_pop_scope: 用户点击取消');
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  PopscopeLogger.info(
                    'cupertino_will_pop_scope: 用户点击确认，返回值: true',
                  );
                  Navigator.pop(dialogContext, true);
                  Navigator.pop(context, true);
                },
                child: const Text('确认'),
              ),
            ],
          ),
        );
        PopscopeLogger.info(
          'cupertino_will_pop_scope: onWillPop 返回结果: ${shouldPop ?? false}',
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('cupertino_will_pop_scope 示例'),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '使用方式',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '本页面使用 cupertino_will_pop_scope 库。\n\n'
                        '特点：\n'
                        '• 需要配置 MaterialApp 的 pageTransitionsTheme\n'
                        '• 使用 ConditionalWillPopScope widget 包裹内容\n'
                        '• onWillPop 需要返回 Future<bool>\n'
                        '• 仅支持 iOS 平台\n\n'
                        '⚠️ 致命问题：\n'
                        '• 滑动时会先滑动一段距离，然后弹回\n'
                        '• 侧滑手势时，即使对话框返回 true 也无法退出\n'
                        '  （系统返回按钮可以正常退出，但侧滑手势不行）\n'
                        '• 用户体验不佳，可能让用户误以为页面可以返回\n'
                        '• 与原生 iOS 行为不一致',
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
                color: Colors.orange,
              ),
              const StepItem(
                number: '2',
                text: '⚠️ 注意：页面会先滑动一段距离，然后弹回',
                color: Colors.red,
              ),
              const StepItem(
                number: '3',
                text: '观察是否弹出确认对话框',
                color: Colors.orange,
              ),
              const StepItem(
                number: '4',
                text: '⚠️ 尝试点击确认，观察是否能正常退出',
                color: Colors.red,
              ),
              const StepItem(
                number: '5',
                text: '对比：使用系统返回按钮 + 确认，可以正常退出',
                color: Colors.orange,
              ),
              const StepItem(
                number: '6',
                text: '查看控制台日志输出',
                color: Colors.orange,
              ),
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
                          'ConditionalWillPopScope(\n'
                          '  shouldAddCallback: true,\n'
                          '  onWillPop: () async {\n'
                          '    // 处理逻辑\n'
                          '    return true; // 或 false\n'
                          '  },\n'
                          '  child: YourWidget(),\n'
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
              const SizedBox(height: 20),
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
                            '注意事项',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• ⚠️ 致命问题1：滑动时会先滑动一段距离，然后弹回\n'
                        '• 用户体验不佳，可能让用户误以为页面可以返回\n'
                        '• 与原生 iOS 行为不一致\n'
                        '• 需要在 MaterialApp 中配置 pageTransitionsTheme\n'
                        '• 多页面嵌套时需要手动管理 shouldAddCallback\n'
                        '• 需要手动处理 context 检查，确保只有顶层页面触发\n'
                        '• 不支持 Flutter 3.12+ 的 PopScope',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.shade700,
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
}
