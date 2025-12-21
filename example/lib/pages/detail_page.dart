import 'package:flutter/material.dart';

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
