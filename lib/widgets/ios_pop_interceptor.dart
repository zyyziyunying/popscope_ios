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
class IosPopInterceptor extends StatefulWidget {
  const IosPopInterceptor({
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
  State<IosPopInterceptor> createState() => _IosPopInterceptorState();
}

class _IosPopInterceptorState extends State<IosPopInterceptor> {
  /// 是否已经注册回调
  bool _isRegistered = false;

  void _handlePopGesture() {
    widget.onPopGesture();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Platform.isIOS && !_isRegistered) {
      /// 使用注册机制，支持多个页面同时使用，避免回调覆盖
      /// 传递 context 作为唯一标识，确保只有顶层页面的回调会被调用
      /// 在 didChangeDependencies 中注册，确保 context 已准备好
      PopscopeIos.registerPopGestureCallback(_handlePopGesture, context);
      _isRegistered = true;
    }
  }

  @override
  void dispose() {
    if (Platform.isIOS && _isRegistered) {
      /// 注销回调，避免内存泄漏
      /// 使用 context 精确注销，不影响其他页面的回调
      PopscopeIos.unregisterPopGestureCallback(context);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: widget.child,
      onPopInvokedWithResult: (didPop, result) {
        /// 处理 Flutter 组件的返回操作（如 AppBar 返回按钮）
        /// iOS 边缘滑动手势通过 registerPopGestureCallback 处理
        /// 但 AppBar 返回按钮等 Flutter 组件的返回操作不会触发原生手势回调
        /// 需要通过 onPopInvokedWithResult 来统一处理
        if (!didPop) {
          widget.onPopGesture();
        }
      },
    );
  }
}
