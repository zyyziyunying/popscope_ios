import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// PopscopeIos 日志工具
///
/// 提供带颜色和 tag 的日志输出功能
/// 参考 Flutter logger 库的实现，默认总是输出颜色代码
class PopscopeLogger {
  /// 日志 tag
  static const String _tag = 'PopscopeIos';

  // ANSI color codes for different log levels
  static const String _reset = '\x1B[0m'; // Reset color
  static const String _yellow = '\x1B[33m'; // Yellow
  static const String _red = '\x1B[31m'; // Red
  static const String _cyan = '\x1B[36m'; // Cyan

  // Colors for log levels
  static const Map<String, String> _logColors = {
    'debug': _cyan,
    'info': _yellow,
    'warn': _yellow,
    'error': _red,
  };

  // Main method to print the log with the appropriate color
  static void log(String level, String message) {
    if (!kDebugMode) return; // Only log in debug mode

    final color =
        _logColors[level] ?? _reset; // Default to reset if no level is found
    final logMessage = '$color$level: $message$_reset';

    developer.log(logMessage,name: _tag);
  }

  // Convenience methods for each log level
  static void debug(String message) {
    log('debug', message);
  }

  static void info(String message) {
    log('info', message);
  }

  static void warn(String message) {
    log('warn', message);
  }

  static void error(String message) {
    log('error', message);
  }
}
