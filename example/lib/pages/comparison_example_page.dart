import 'package:flutter/material.dart';
import 'package:popscope_ios_example/pages/compare/cupertino_will_pop_scope_example_page.dart';
import 'package:popscope_ios_example/pages/compare/popscope_ios_example_page.dart';

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
                        Icon(
                          Icons.compare_arrows,
                          color: Colors.purple.shade700,
                        ),
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
                      builder: (context) =>
                          const CupertinoWillPopScopeExamplePage(),
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
                          Icon(
                            Icons.library_books,
                            color: Colors.orange.shade700,
                          ),
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

  /// 构建对比表格
  Widget _buildComparisonTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('特性', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Padding(padding: EdgeInsets.all(8), child: Text('配置要求')),
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
            const Padding(padding: EdgeInsets.all(8), child: Text('使用方式')),
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
            const Padding(padding: EdgeInsets.all(8), child: Text('多页面嵌套')),
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
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
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
        TableRow(
          decoration: BoxDecoration(color: Colors.red.shade50),
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    Icons.bug_report,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '侧滑手势\n对话框',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '❌ 侧滑时对话框返回\ntrue 也无法退出',
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
                '✅ 侧滑和系统按钮\n行为一致',
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
