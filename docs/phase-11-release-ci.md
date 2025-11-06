# Phase 11 发布与 CI 技术设计

## 1. 目标
建立自动化持续集成与发布流程：构建、测试、格式化、版本标记；准备 App Store 上架所需素材与隐私合规；支持语义化版本。

## 2. 范围
- CI 流程（GitHub Actions 或其他）：格式化、单元测试、构建
- 版本策略：0.x 迭代 -> 1.0 稳定
- 自动生成 Release Notes（从 PR 标题汇总）
- App Store 元数据文件结构准备

## 3. CI Job 设计
| Job | 步骤 |
|-----|------|
| lint | 安装 SwiftFormat -> 校验无 diff |
| test | 构建测试目标 -> 运行所有单元与 Snapshot |
| build | Xcodebuild iOS 26 模拟器构建成功 |
| release (manual) | bump version -> tag -> 生成 notes |

示例命令：
```
xcodebuild -scheme BabyMeasure -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## 4. 版本号策略
采用 `MAJOR.MINOR.PATCH`：
- MAJOR: 架构或数据兼容性破坏
- MINOR: 新功能向后兼容
- PATCH: 修复与微小增强

预版本标签：`-beta.N` 在 1.0 前测试分发。

## 5. Release Notes 生成
脚本扫描合并的 PR：标题前缀分类：
- Feat: 新功能
- Fix: 修复
- Docs: 文档
- Perf: 性能
- Refactor: 重构
输出 Markdown -> 附加到 GitHub Release。

## 6. 任务拆分
- [ ] 添加 GitHub Actions 工作流 yaml（lint + test + build）
- [ ] 编写 release 脚本收集 PR 标题
- [ ] 版本号存储位置（如 Xcode project 或 Info.plist）
- [ ] 添加 CHANGELOG.md 初始结构
- [ ] 准备上架所需隐私声明与截图占位

## 7. 测试计划
| 测试 | 内容 |
|------|------|
| testVersionBumpScript | 版本递增逻辑正确 |
| testReleaseNotesGrouping | PR 标题分类汇总正确 |
| ciWorkflowDryRun | 工作流文件语法检查 |

## 8. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| CI 构建时间过长 | 开发反馈慢 | 缓存依赖 & 并行化 |
| 版本号未同步多处 | 发行混乱 | 单一来源 (脚本写 Info.plist) |
| Release Notes 不准确 | 用户理解偏差 | PR 模板强制分类前缀 |

## 9. 可选扩展
- Fastlane 集成自动截图
- TestFlight 自动分发 Beta 构建

## 10. 完成标准
- CI 三个核心 Job 稳定通过
- 有首个语义版本 Tag 与 CHANGELOG 条目
- 发布脚本成功生成 Notes
