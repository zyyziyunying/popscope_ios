import 'package:flutter/material.dart';
import 'package:popscope_ios/popscope_ios.dart';
import 'package:popscope_ios/utils/logger.dart';
import 'package:popscope_ios_example/widgets/step_item.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';

/// 对比示例页面
///
/// 展示 popscope_ios 与 cupertino_will_pop_scope 的对比
/// 突出 popscope_ios 的优势和独特之处
class ComparisonExamplePage extends StatelessWidget {
  const ComparisonExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('库对比示例'),
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
                        Icon(Icons.compare_arrows, color: Colors.purple.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '对比说明',
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
                      '本页面展示了 popscope_ios 与 cupertino_will_pop_scope 的对比。\n\n'
                      '通过实际体验，您可以了解两个库的差异和 popscope_ios 的优势。\n\n'
                      '⚠️ 关键差异：cupertino_will_pop_scope 会滑动一段距离，'
                      '而 popscope_ios 直接拦截手势，不滑动。',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 对比表格
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '功能对比',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildComparisonTable(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 测试入口
            const Text(
              '测试页面：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // cupertino_will_pop_scope 示例
            Card(
              color: Colors.orange.shade50,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CupertinoWillPopScopeExamplePage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.library_books, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'cupertino_will_pop_scope',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• 需要配置 MaterialApp 的 pageTransitionsTheme\n'
                        '• 使用 ConditionalWillPopScope widget\n'
                        '• 基于 WillPopScope，需要返回 Future<bool>\n'
                        '• 仅支持 iOS 平台\n'
                        '⚠️ 致命问题：会滑动一段距离然后弹回',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // popscope_ios 示例
            Card(
              color: Colors.green.shade50,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PopscopeIosExamplePage(),
                    ),
                  );
                },
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
                            'popscope_ios',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '推荐',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• 无需配置，开箱即用\n'
                        '• 支持多种使用方式（registerPopGestureCallback、PlatformPopScope）\n'
                        '• 支持回调栈管理，多页面嵌套无压力\n'
                        '• 支持 Flutter 3.12+ 的 PopScope 集成\n'
                        '• 自动处理 context 检查，确保只有顶层页面触发',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '特性',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'cupertino_will_pop_scope',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'popscope_ios',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('配置要求'),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '需要配置\npageTransitionsTheme',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '无需配置\n开箱即用',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('使用方式'),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'ConditionalWillPopScope\nwidget',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '多种方式\n灵活选择',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('多页面嵌套'),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '需要手动管理',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '自动管理回调栈',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Context 检查'),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '需要手动处理',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '自动检查',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('PopScope 集成'),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '不支持',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '完美支持',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(color: Colors.red.shade50),
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 4),
                  const Text(
                    '滑动行为',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '❌ 会滑动一段距离\n然后弹回',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '✅ 直接拦截\n不滑动',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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
          builder: (context) => AlertDialog(
            title: const Text('cupertino_will_pop_scope'),
            content: const Text('确定要返回吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('确认'),
              ),
            ],
          ),
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
                          Icon(Icons.info_outline, color: Colors.orange.shade700),
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
                          style: TextStyle(fontFamily: 'monospace', fontSize: 12),
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
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.red.shade700),
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
                        '• ⚠️ 致命问题：滑动时会先滑动一段距离，然后弹回\n'
                        '• 用户体验不佳，可能让用户误以为页面可以返回\n'
                        '• 与原生 iOS 行为不一致\n'
                        '• 需要在 MaterialApp 中配置 pageTransitionsTheme\n'
                        '• 多页面嵌套时需要手动管理 shouldAddCallback\n'
                        '• 需要手动处理 context 检查，确保只有顶层页面触发\n'
                        '• 不支持 Flutter 3.12+ 的 PopScope',
                        style: TextStyle(fontSize: 14, color: Colors.red.shade700),
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

/// popscope_ios 示例页面
class PopscopeIosExamplePage extends StatefulWidget {
  const PopscopeIosExamplePage({super.key});

  @override
  State<PopscopeIosExamplePage> createState() =>
      _PopscopeIosExamplePageState();
}

class _PopscopeIosExamplePageState extends State<PopscopeIosExamplePage> {
  Object? _callbackToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _callbackToken ??= PopscopeIos.registerPopGestureCallback(() {
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
    if (_callbackToken != null) {
      PopscopeIos.unregisterPopGestureCallback(_callbackToken!);
    }
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
            const StepItem(
              number: '4',
              text: '查看控制台日志输出',
              color: Colors.green,
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
                      style: TextStyle(fontSize: 14, color: Colors.green.shade700),
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

