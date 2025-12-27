# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**popscope_ios** is a Flutter plugin that intercepts iOS left-edge swipe back gestures (interactivePopGesture). It solves the problem where setting `PopScope.canPop = false` completely disables the iOS swipe gesture, leaving no way to handle custom back logic.

## Build & Development Commands

```bash
# Get dependencies (run from project root)
flutter pub get

# Run the example app
cd example && flutter run

# Run tests
flutter test

# Run single test file
flutter test test/popscope_ios_method_channel_test.dart

# Analyze code
flutter analyze
```

## Architecture

### Platform Communication Flow
```
iOS Native                    Flutter
PopscopeIosPlugin.swift  <->  MethodChannelPopscopeIos  <->  PopscopeIos API
                                                              |
                                                         Widgets (PlatformPopScope, IosPopInterceptor)
```

### Key Components

**Dart Layer (`lib/`):**
- `popscope_ios.dart` - Main API entry point, exports widgets and callback registration methods
- `popscope_ios_platform_interface.dart` - Platform interface abstraction
- `popscope_ios_method_channel.dart` - Method channel implementation with callback stack management
- `widgets/platform_popscope.dart` - Cross-platform PopScope wrapper (auto-selects iOS interceptor vs standard PopScope)
- `widgets/ios_pop_interceptor.dart` - iOS-specific gesture interceptor widget

**iOS Native Layer (`ios/popscope_ios/Sources/`):**
- `PopscopeIosPlugin.swift` - Native plugin that intercepts `UINavigationController.interactivePopGestureRecognizer`

### Callback Stack Mechanism

The plugin uses a callback stack to handle multiple pages registering gesture callbacks:
- `registerPopGestureCallback(callback, context)` - Pushes callback onto stack with optional BuildContext
- `unregisterPopGestureCallback(token)` - Removes callback by token
- Only the topmost valid callback (where page is still at top of navigation stack) gets invoked
- Callbacks auto-cleanup when their associated context becomes unmounted

### Usage Patterns

**Recommended - Use widgets:**
```dart
// PlatformPopScope handles iOS/other platform differences automatically
PlatformPopScope(
  canPop: false,
  onPop: () => showConfirmDialog(),
  child: YourPage(),
)

// Or use IosPopInterceptor directly for iOS-only handling
IosPopInterceptor(
  onPopGesture: () => handleBackGesture(),
  child: YourPage(),
)
```

**Deprecated - Direct API calls:**
Global `setNavigatorKey()` and `setOnLeftBackGesture()` are deprecated because they can cause multiple pops when multiple pages use them.

## Example App Structure

Located in `example/lib/`:
- `main.dart` - Entry point with navigation hub (HomePage)
- `pages/` - Individual example pages demonstrating different use cases
- `widgets/` - Reusable UI components like `ExampleCard`

When adding new example pages: create file in `pages/`, add `ExampleCard` in `main.dart`.

## Git Commit Guidelines

**IMPORTANT**: All git commit messages in this project MUST be written in Chinese (中文).

- Commit message format: `<类型>: <描述>`
- Common types: `特性`(feature), `修复`(bugfix), `文档`(docs), `重构`(refactor), `测试`(test), `样式`(style)
- Example: `特性: 添加新的手势拦截功能`
- Example: `修复: 解决内存泄漏问题`
- Example: `文档: 更新 README 使用说明`

This applies to all commits created by Claude Code when working on this project.
