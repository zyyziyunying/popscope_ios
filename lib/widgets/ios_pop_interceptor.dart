import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:popscope_ios/popscope_ios.dart';

/// iOS 边缘滑动手势拦截器
///
/// 仅在 iOS 平台上拦截边缘滑动手势，并在手势触发时执行回调
/// 组件销毁时自动清理拦截器资源
///
/// 使用场景：当 PopScope.canPop 为 false 时，
/// iOS 会完全禁用边缘滑动手势，此时可以使用此组件手动拦截手势并执行自定义逻辑
class IosPopGestureInterceptor extends StatefulWidget {
  const IosPopGestureInterceptor({
    super.key,
    required this.child,
    required this.onPopGesture,
  });

  /// 子组件
  final Widget child;

  /// 边缘滑动手势触发时的回调
  /// 当用户从左边缘向右滑动时调用
  final VoidCallback onPopGesture;

  @override
  State<IosPopGestureInterceptor> createState() =>
      _IosPopGestureInterceptorState();
}

class _IosPopGestureInterceptorState extends State<IosPopGestureInterceptor> {
  void _handlePopGesture() {
    widget.onPopGesture();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      PopscopeIos.setOnLeftBackGesture(_handlePopGesture);
    }
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      /// 清除回调，避免内存泄漏
      PopscopeIos.setOnLeftBackGesture(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: widget.child);
  }
}
