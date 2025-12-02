import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:popscope_ios/popscope_ios.dart';
import 'package:popscope_ios/popscope_ios_platform_interface.dart';
import 'package:popscope_ios/popscope_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPopscopeIosPlatform
    with MockPlatformInterfaceMixin
    implements PopscopeIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  Future<void> setup() => Future.value();
  
  @override
  void setOnSystemBackGesture(VoidCallback? callback) {
    // Mock implementation
  }
  
  @override
  void setNavigatorKey(GlobalKey<NavigatorState>? navigatorKey, {bool autoHandle = true}) {
    // Mock implementation
  }
}

void main() {
  final PopscopeIosPlatform initialPlatform = PopscopeIosPlatform.instance;

  test('$MethodChannelPopscopeIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPopscopeIos>());
  });

  test('getPlatformVersion', () async {
    PopscopeIos popscopeIosPlugin = PopscopeIos();
    MockPopscopeIosPlatform fakePlatform = MockPopscopeIosPlatform();
    PopscopeIosPlatform.instance = fakePlatform;

    expect(await popscopeIosPlugin.getPlatformVersion(), '42');
  });
}
