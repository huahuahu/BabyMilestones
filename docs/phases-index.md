# BabyMilestones 分阶段技术设计索引

> 本目录汇总 0–11 阶段技术设计，统一格式：目标 / 范围 / 关键决策 / 数据与状态 / 接口与示例 / 任务拆分 / 测试与验证 / 风险与缓解 / 可选扩展。

| Phase | 标题 | 目标概述 |
|-------|------|----------|
| 00 | 基础工程与架构 | 奠定项目结构、编码规范与核心模型草案 |
| 01 | 本地存储层 | 建立 SwiftData/Core Data Schema 与存储服务 |
| 02 | 录入与列表 UI | 初步交互：儿童列表、记录添加、历史浏览 |
| 03 | 生长标准解析 | 将 /resource 数据解析为结构化标准集 |
| 04 | 生长曲线图表 | 用户记录 vs 百分位标准曲线渲染 |
| 05 | 多儿童管理 | 状态隔离、切换与编辑档案 |
| 06 | iCloud 同步 | 可选云同步与冲突解决 |
| 07 | 数据导出与分享 | CSV/JSON 导出与系统分享集成 |
| 08 | 高级体验增强 | iOS 26 视觉与可访问性增强 |
| 09 | 安全与隐私 | 加密、清除、权限与合规文档 |
| 10 | 社区与扩展 | 贡献流程与后续扩展路线图 |
| 11 | 发布与 CI | 自动化构建测试与发布流程 |

## 通用设计要点
- 使用现代 SwiftUI：@State / @Observable / @Environment
- 避免 ViewModel；状态就近管理，动作向上冒泡
- 异步统一 async/await；最小化 Combine
- 单元 + 集成 + Snapshot + 性能 多层测试策略
- 中文/英文双语与辅助功能（阶段 08 加强）

下述各文件提供详细技术设计：
```
phase-00-foundation.md
phase-01-local-storage.md
phase-02-record-entry-ui.md
phase-03-growth-standards.md
phase-04-growth-charts.md
phase-05-multi-child-management.md
phase-06-icloud-sync.md
phase-07-export-share.md
phase-08-enhanced-experience.md
phase-09-security-privacy.md
phase-10-community-extensions.md
phase-11-release-ci.md
```
