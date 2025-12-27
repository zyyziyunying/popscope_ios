# 发布检查清单

在发布 `popscope_ios_plus` 到 pub.dev 之前，请确保完成以下所有步骤：

## 📋 代码准备

- [x] 包名已从 `popscope_ios` 重命名为 `popscope_ios_plus`
- [x] 所有 Dart 文件中的 import 语句已更新
- [x] iOS 原生代码中的 Method Channel 名称已更新
- [x] 测试文件中的包引用已更新
- [x] 所有测试通过 (`flutter test`)

## 📝 文档更新

- [x] README.md 已更新并说明这是增强版
- [x] CHANGELOG.md 已创建并记录所有改进
- [x] API 文档注释完整且详细
- [x] 包含最佳实践示例和错误示例

## 🔧 配置文件

- [ ] 更新 `pubspec.yaml` 中的 GitHub 仓库 URL
  - 当前：`https://github.com/YOUR_USERNAME/popscope_ios_plus`
  - 需要：你的实际 GitHub 仓库地址
- [x] 版本号设置为 `0.1.0`
- [x] 描述信息完整且准确
- [ ] LICENSE 文件存在且正确

## 🔍 质量检查

- [x] 运行 `flutter analyze` 无错误
- [x] 运行 `flutter test` 全部通过
- [ ] 运行 `flutter pub publish --dry-run` 检查发布准备
- [ ] 检查包大小合理（无不必要的文件）

## 📦 iOS 原生检查

- [x] podspec 文件已更新
- [x] Package.swift 已更新
- [x] Swift 插件类名称和 channel 名称一致

## 🌐 GitHub 准备

- [ ] 在 GitHub 创建新仓库 `popscope_ios_plus`
- [ ] 初始化 git 仓库并推送代码
- [ ] 创建 v0.1.0 标签
- [ ] 编写清晰的 README（在 GitHub 上也清晰可读）

## ✅ 发布前最后检查

### 1. 更新仓库 URL

```bash
# 编辑 pubspec.yaml
vim pubspec.yaml

# 将 YOUR_USERNAME 替换为你的 GitHub 用户名
# 例如: https://github.com/zyyziyunying/popscope_ios_plus
```

### 2. 验证包

```bash
cd /Users/zyyziyunying/popscope_ios
flutter pub publish --dry-run
```

### 3. 检查输出

确保输出中：
- ✅ 没有警告或错误
- ✅ 包大小合理（通常 < 1MB）
- ✅ 所有必要文件都包含
- ✅ LICENSE 文件存在

### 4. 初始化 Git（如果还没有）

```bash
cd /Users/zyyziyunying/popscope_ios
git init
git add .
git commit -m "chore: rename package to popscope_ios_plus and add enhancements

- Renamed from popscope_ios to popscope_ios_plus
- Changed callback system from token-based to context-based
- Improved performance with O(1) operations
- Added automatic cleanup for unmounted callbacks
- Enhanced documentation with best practices
- Added runtime validation and assertions

🤖 Generated with Claude Code"

# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/popscope_ios_plus.git

# 推送代码
git push -u origin main

# 创建标签
git tag v0.1.0
git push origin v0.1.0
```

## 🚀 发布命令

```bash
# 最终发布（确认所有检查通过后）
flutter pub publish
```

## 📢 发布后

- [ ] 在 GitHub 创建 Release，附上 CHANGELOG
- [ ] 更新个人博客/文档说明新包
- [ ] 在相关社区分享（如有）

---

## ⚠️ 重要提醒

1. **包名不可更改**：一旦发布，包名不能修改
2. **版本只能递增**：已发布的版本号不能重复使用
3. **LICENSE 必须存在**：pub.dev 要求有 LICENSE 文件
4. **GitHub URL 必须正确**：确保指向正确的仓库

## 🆘 如果遇到问题

- pub.dev 发布指南：https://dart.dev/tools/pub/publishing
- Flutter 插件开发：https://docs.flutter.dev/packages-and-plugins/developing-packages
- pub.dev 包评分说明：https://pub.dev/help/scoring
