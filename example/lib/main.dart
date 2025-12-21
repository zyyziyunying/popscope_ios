import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popscope_ios/popscope_ios.dart';
import 'package:popscope_ios_example/pages/basic_example_page.dart';
import 'package:popscope_ios_example/pages/custom_gesture_page.dart';
import 'package:popscope_ios_example/pages/popscope_example_page.dart';
import 'package:popscope_ios_example/pages/platform_popscope_example_page.dart';

/// 创建全局 Navigator Key
///
/// 这个 key 用于让插件能够访问 Flutter 的导航系统，
/// 从而在检测到左滑返回手势时自动调用 maybePop()
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 重要：必须将 navigatorKey 关联到 MaterialApp
      // 这样插件才能访问导航系统
      navigatorKey: navigatorKey,
      title: 'Popscope iOS 示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// 主页面：作为所有测试页面的导航中心
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _platformVersion = 'Unknown';
  final _popscopeIosPlugin = PopscopeIos();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _popscopeIosPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popscope iOS 示例'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题区域
            const Icon(Icons.apps, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              '测试页面导航',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Running on: $_platformVersion',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // PlatformPopScope 示例（推荐）
            _buildExampleCard(
              context: context,
              title: 'PlatformPopScope（推荐）',
              description: '自动处理初始化和销毁，推荐使用方式',
              icon: Icons.star,
              color: Colors.orange,
              badge: '推荐',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlatformPopScopeExamplePage(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 基础示例
            _buildExampleCard(
              context: context,
              title: '基础示例',
              description: '使用 setNavigatorKey 自动处理返回手势',
              icon: Icons.settings,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BasicExamplePage(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 自定义手势处理示例
            _buildExampleCard(
              context: context,
              title: '自定义手势处理',
              description: '通过按钮控制手势的启用/禁用，显示确认对话框',
              icon: Icons.touch_app,
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomGesturePage(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // PopScope 示例
            _buildExampleCard(
              context: context,
              title: 'PopScope 示例',
              description: '使用 PopScope widget 配合 onPopInvoked 控制返回行为',
              icon: Icons.science,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PopScopeExamplePage(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // 说明卡片
            Card(
              color: Colors.grey.shade50,
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
                          '使用说明',
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
                      '点击上方任意示例卡片进入对应的测试页面，'
                      '体验不同的返回手势处理方式。',
                      style: TextStyle(fontSize: 14),
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

  Widget _buildExampleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
