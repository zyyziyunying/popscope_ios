import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:popscope_ios/popscope_ios.dart';

// 创建全局 Navigator Key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 自定义处理示例：禁用自动导航，手动控制返回行为
/// 
/// 这个示例展示了如何在检测到返回手势时显示确认对话框
void main() {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  final plugin = PopscopeIos();
  
  // 设置 Navigator Key，但禁用自动处理
  plugin.setNavigatorKey(navigatorKey, autoHandle: false);
  
  // 自定义返回手势处理
  plugin.setOnSystemBackGesture(() {
    final context = navigatorKey.currentContext;
    if (context != null && Navigator.of(context).canPop()) {
      // 显示确认对话框
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('确认返回'),
            content: const Text('您确定要返回上一页吗？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // 关闭对话框
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // 关闭对话框
                  Navigator.of(context).pop(); // 返回上一页
                },
                child: const Text('确认'),
              ),
            ],
          );
        },
      );
    }
  });
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          await _popscopeIosPlugin.getPlatformVersion() ?? 'Unknown platform version';
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
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('自定义处理示例'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 80, color: Colors.purple),
              const SizedBox(height: 30),
              const Text(
                '自定义返回处理模式',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('Running on: $_platformVersion'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                    ),
                  );
                },
                child: const Text('打开详情页'),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  '在详情页尝试左滑返回\n将会弹出确认对话框',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('详情页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit_document, size: 100, color: Colors.purple),
            const SizedBox(height: 30),
            Text(
              _hasUnsavedChanges ? '有未保存的更改' : '没有未保存的更改',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _hasUnsavedChanges ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasUnsavedChanges = !_hasUnsavedChanges;
                });
              },
              child: Text(_hasUnsavedChanges ? '标记为已保存' : '模拟编辑'),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '尝试左滑返回，系统会弹出确认对话框\n这样可以防止意外丢失数据',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

