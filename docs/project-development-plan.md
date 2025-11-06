# BabyMilestones 分阶段开发规划

> 版本：2025-11-06（初稿）  
> 目标：为 0–7 岁儿童提供生长指标记录、标准曲线对比、里程碑与回忆管理，多端（iOS/iPadOS）SwiftUI 原生应用。

---
## 1. 项目概览
BabyMilestones 是一个开源的 SwiftUI 应用，用于记录并分析儿童（0–7 岁）身高、体重、头围等生长发育数据。通过卫生部标准生成百分位与趋势图，支持多儿童管理、本地与可选 iCloud 同步、数据导出与分享，后续扩展成长里程碑和回忆照片。

---
## 2. 需求拆分
### 2.1 功能性需求
1. 儿童档案：新增/编辑/删除，多儿童切换（姓名、性别、生日、头像）。  
2. 生长数据记录：按日期录入身高、体重、头围，可扩展其它指标。  
3. 单位与校验：默认公制（cm/kg），范围合理性校验。  
4. 标准生长曲线：解析 `/resource/` 卫生部标准（转 CSV）。  
5. 百分位计算：显示当前值所属百分位与区间（正常/偏低/偏高）。  
6. 图表：交互式曲线（多条标准百分位线 + 用户数据点），时间段切换。  
7. 本地存储：离线可用（初期 JSON，后期可迁移 Core Data + CloudKit）。  
8. iCloud 同步：开关控制，跨设备合并与冲突解决。  
9. 导出分享：CSV / JSON / PDF 报告、图表截图分享。  
10. 成长里程碑：预置库 + 自定义，完成状态与日期。  
11. 回忆（照片/视频/备注）与里程碑/记录关联。  
12. 多语言：中文 + 英文（String Catalog）。  
13. Onboarding：首次启动引导与隐私声明。  
14. 设置：单位切换、同步开关、数据管理、隐私政策。  
15. 无障碍：动态字体、VoiceOver、对比度适配。

### 2.2 非功能性需求
| 类别 | 要求 |
|------|------|
| 隐私 | 最小数据采集，可一键清空；不上传除必要同步外数据 |
| 性能 | 图表 1000+ 点仍流畅 (>50fps)；启动 <1.5s（目标） |
| 可维护性 | 模型 + Store 分层，避免巨型 Manager；无过度 ViewModel |
| 可扩展 | 指标与标准可迭代增加，不破坏现有结构 |
| 可测试 | 百分位计算、解析、导出、存储逻辑均有单元测试 |
| 离线 | 主要功能不依赖网络，同步失败不影响使用 |
| 安全 | iCloud 使用系统加密；后期可引入本地加密（选项） |
| 开源规范 | README / CONTRIBUTING / Issue 模板 / 许可证 |
| 无障碍 | 文本标签与语义良好，颜色对比合格 |

### 2.3 技术栈
- Swift 6 / SwiftUI（iOS 26 SDK）  
- 原生状态管理：`@State` / `@Observable` / `@Environment`  
- 持久化：Phase 1 JSON → Phase 5 Core Data + CloudKit（视复杂度）  
- 图表：SwiftUI Canvas 或 `Charts`（看兼容策略）  
- 百分位：线性插值（后续可扩展 LMS）  
- 导出：CSV/JSON + PDFKit  
- 测试：XCTest（含性能与逻辑）

---
## 3. 分阶段实施
### Phase 0：基础骨架
- 验证现有 App 能构建运行。  
- 整理目录结构（Models/ Views/ Navigation/ Stores/）。  
- 添加 README 路线与目标。  
- 最小数据模型 `Child` / `GrowthMeasurement（初版）`。  
- 初始化示例数据（仅开发模式）。

### Phase 1：本地数据 MVP
- 扩展测量模型，录入界面与校验。  
- 引入 Store：`ChildStore` / `GrowthStore`。  
- JSON 持久化协议 `DataPersisting + JSONDataStore`。  
- 单元测试：创建儿童、同日覆盖策略、持久化读写。  
- Onboarding 流程（添加第一个儿童）。

### Phase 2：标准与百分位
- 将 PDF 标准转为 `growth_standard.csv`。  
- 模型：`GrowthStandardRow / GrowthStandardIndex`。  
- Loader：`CSVGrowthStandardLoader`（容错解析）。  
- 百分位计算器：`GrowthPercentileCalculator`（线性插值 + Band 分类）。  
- UI：录入后显示百分位说明。  
- 测试：解析正确性、插值边界、缺失数据处理。

### Phase 3：图表可视化
- 设计多百分位线 + 用户数据点叠加。  
- 时间范围切换（0–12M / 1–3Y / 3–7Y / 全部）。  
- 交互：长按浮层、点高亮。  
- 采样/降噪（大数据点优化）。  
- 性能测试（1000+ 点）。

### Phase 4：多儿童体验强化
- 主页切换栏（头像水平滚动）。  
- 当前儿童概览（最近记录 + 进度）。  
- Store 环境注入整合于根视图。  
- 里程碑基础展示（可延后完成状态逻辑）。

### Phase 5：iCloud 同步
- 选型：Core Data + NSPersistentCloudKit 或自定义 CloudKit。  
- 迁移脚本：JSON → Core Data。  
- 同步策略：增量、冲突（最新修改优先）。  
- UI：同步状态与开关。  
- 测试：离线/上线、冲突模拟、多设备一致性。

### Phase 6：导出与分享
- `ExportService`：CSV / JSON 输出。  
- PDF 报告（基本信息 + 图表截图）。  
- 分享：系统 Share Sheet。  
- 测试：编码正确、空数据处理、特殊字符。

### Phase 7：里程碑与回忆拓展
- 数据结构完善：`MilestoneStore / MemoryStore`。  
- 里程碑状态切换、筛选。  
- 照片/视频引用（`PhotosPicker`）。  
- 与生长记录联动（同日关联）。  
- 测试：权限拒绝、关联更新。

### Phase 8：质量、本地化、无障碍
- 抽取所有文案到 String Catalog。  
- 动态字体 / VoiceOver 标签修正。  
- 颜色对比与深色模式。  
- 性能微调（启动、内存）。  
- 测试：语言切换、Accessibility。

### Phase 9：开源与社区
- CONTRIBUTING.md / ISSUE_TEMPLATE / PULL_REQUEST_TEMPLATE。  
- Roadmap.md（后续特性：家庭共享、成长建议算法、推送提醒）。  
- GitHub Actions：构建、测试、格式化。  
- 隐私与安全声明（双语）。

---
## 4. 模型与核心骨架摘要
- 标准：`GrowthStandardRow` + 百分位插值（p3/p15/p50/p85/p97）。  
- 百分位结果：`PercentileResult`（approx + band + comment）。  
- Store 拆分：`ChildStore` / `GrowthStore` / `MilestoneStore` / `MemoryStore`。  
- 导出：`ExportService.exportChildData(...)`。  
- 同步预留：`CloudSyncManager`（push/pull/冲突）。

---
## 5. 测试策略
### 测试类型
- 单元：解析 / 百分位 / 持久化 / 导出。  
- 性能：图表绘制、启动。  
- UI：关键流程（新增 → 录入 → 查看 → 导出）。  
- 回归：多儿童隔离、覆盖逻辑、同步冲突。  

### 示例用例
| 名称 | 目的 |
|------|------|
| ChildStoreTests | 多儿童添加与切换一致性 |
| GrowthStoreTests | 同日同类型数据覆盖策略 |
| GrowthStandardLoaderTests | CSV 行解析与缺失列容错 |
| PercentileCalculatorTests | 精确命中与插值边界 |
| ExportServiceTests | CSV/JSON 字段与格式正确 |
| MigrationTests (后期) | JSON → Core Data 迁移正确性 |

### 性能基准（目标）
- 1000 条测量点：图表准备 < 200ms。  
- 启动：冷启动 < 1.5s（优化阶段）。

---
## 6. 风险与缓解
| 风险 | 描述 | 缓解 |
|------|------|------|
| 标准数据难解析 | PDF 表结构复杂 | 手工转 CSV + 脚本验证 |
| 同步复杂度高 | 早期引入阻碍迭代 | 延后至 Phase 5；先稳定本地模型 |
| 图表性能 | 大数据点卡顿 | 采样 + 绘制层优化 |
| 百分位准确性质疑 | 用户对含义不清晰 | UI 说明 + 帮助页解释 |
| 多语言拖延 | 字符串硬编码泛滥 | 提前约定集中抽取策略（Phase 8） |
| 数据丢失风险 | 存储或迁移失败 | 增加自动备份导出选项（后续） |

---
## 7. 迭代与版本节奏
- 每阶段结束：打 Tag + 更新 CHANGELOG。  
- 主分支保持可构建与基础测试通过。  
- 引入轻量 Feature Flag（如 iCloud 启用）。

---
## 8. 后续扩展（Roadmap 预告）
- 家庭共享（多个监护人协同）。  
- 提醒功能（录入计划、疫苗节点）。  
- 成长建议生成（基于趋势 + 百分位段）。  
- 数据分析仪表盘（月度增速、异常波动）。  
- 安全：本地敏感数据加密、数据留存策略。  

---
## 9. 快速下一步行动建议
1. 落地 `GrowthStandardRow / Calculator`。  
2. 引入 `ChildStore` 环境注入。  
3. CSV 标准样例创建与单元测试。  
4. 简单录入 UI → 百分位展示。  

---
## 10. 维护说明
- 所有新增模型需补充测试。  
- 标准 CSV 任何修改需更新版本号与变更日志。  
- 性能测试脚本集中放 `Tests/Performance/`（后期创建）。  

> 本文档将随阶段推进更新，建议后续拆分 Roadmap 与开发者指南独立文件。
