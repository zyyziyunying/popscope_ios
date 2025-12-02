import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'popscope_ios_platform_interface.dart';

class PopscopeIos {
  Future<String?> getPlatformVersion() {
    return PopscopeIosPlatform.instance.getPlatformVersion();
  }

  static void setNavigatorKey(GlobalKey<NavigatorState>? navigatorKey, {bool autoHandle = true}) {
    PopscopeIosPlatform.instance.setNavigatorKey(navigatorKey, autoHandle: autoHandle);
  }


  static void setOnLeftBackGesture(VoidCallback? callback) {
    PopscopeIosPlatform.instance.setOnSystemBackGesture(callback);
  }
}
