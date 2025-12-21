import 'package:flutter/material.dart';

/// 确认返回对话框工具
///
/// 封装了通用的确认返回对话框逻辑，可以在需要拦截返回操作时使用
class ConfirmPopDialog {
  /// 显示确认返回对话框
  ///
  /// [context] 用于显示对话框的 BuildContext
  /// [title] 对话框标题，默认为 '确认返回'
  /// [content] 对话框内容，默认为 '检测到左滑返回手势，是否确认返回？'
  /// [onConfirm] 确认回调，默认会关闭对话框并返回上一页
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? content,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? '确认返回'),
        content: Text(content ?? '检测到左滑返回手势，是否确认返回？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              if (onConfirm != null) {
                onConfirm();
              } else {
                Navigator.pop(context); // 返回上一页
              }
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}

