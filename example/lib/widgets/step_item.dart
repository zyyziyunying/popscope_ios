import 'package:flutter/material.dart';

/// 步骤项组件
///
/// 用于展示测试步骤，包含序号和描述文本
class StepItem extends StatelessWidget {
  const StepItem({
    super.key,
    required this.number,
    required this.text,
    this.color = Colors.blue,
  });

  /// 步骤序号
  final String number;

  /// 步骤描述文本
  final String text;

  /// 序号圆圈的颜色，默认为蓝色
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

