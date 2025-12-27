# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-27

### Added
- **Context-based callback management**: Use `BuildContext` as callback identifier instead of internal token counter
- **Per-page callback registration**: `registerPopGestureCallback(callback, context)` API for page-level gesture handling
- **Automatic cleanup**: Callbacks are automatically cleaned up when pages are unmounted
- **Performance optimization**: O(1) callback lookup and deletion using Map instead of List
- **Enhanced documentation**: Comprehensive API documentation with best practices and error examples
- **Validation and assertions**: Runtime validation with `context.mounted` checks and development-mode assertions
- **Better logging**: Enhanced debug logging with context hashCode tracking
- **Professional widgets**: `PlatformPopScope` and `IosPopInterceptor` for easy integration

### Changed
- **Package renamed** from `popscope_ios` to `popscope_ios_plus`
- **API redesigned**: Replaced token-based callback system with context-based system
- **Callback storage**: Changed from `List<_CallbackEntry>` to `Map<BuildContext, _CallbackEntry>` for better performance
- **Method signatures**: Updated `registerPopGestureCallback` and `unregisterPopGestureCallback` to require `BuildContext`

### Deprecated
- `setNavigatorKey()`: Use `registerPopGestureCallback()` with `BuildContext` instead
- `setOnLeftBackGesture()`: Use `registerPopGestureCallback()` with `BuildContext` instead

### Improved
- **Widget lifecycle integration**: Proper use of `didChangeDependencies()` for callback registration
- **Memory management**: Proactive cleanup of unmounted callbacks during gesture handling
- **Error handling**: Better error messages and stack trace preservation with `rethrow`
- **Test coverage**: All existing tests passing with new implementation
- **Documentation**: Detailed examples showing correct and incorrect usage patterns

### Fixed
- Potential callback ordering issues when `didChangeDependencies()` is called multiple times
- Memory leaks from callbacks not being properly cleaned up
- Performance issues with O(n) operations on callback list
- Missing validation for unmounted contexts

---

## Comparison with original popscope_ios

This package (`popscope_ios_plus`) is an enhanced fork of the original `popscope_ios`. Key improvements include:

| Feature | popscope_ios | popscope_ios_plus |
|---------|--------------|-------------------|
| Callback Management | Token-based | Context-based ✅ |
| Performance | O(n) operations | O(1) operations ✅ |
| Automatic Cleanup | Manual only | Automatic + Manual ✅ |
| Multi-page Support | Global callbacks | Per-page callbacks ✅ |
| Documentation | Basic | Comprehensive ✅ |
| Best Practices Guide | No | Yes ✅ |
| Validation | None | Runtime + Assertions ✅ |
| Memory Safety | Basic | Enhanced ✅ |

---

## Original Versions (from popscope_ios)

## [1.0.0] - Previous Release

* 🎉 初始版本发布
* ✨ 实现 iOS 左滑返回手势拦截功能
* 🤖 支持自动处理页面返回（通过 `setNavigatorKey`）
* 🔧 支持业务自定义处理逻辑（通过 `setOnLeftBackGesture`）
* 📚 完善的文档和示例代码

## [0.0.1] - Initial Development

* 初始开发版本
