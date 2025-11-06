# Phase 00 基础工程与架构设计

## 1. 目标
建立稳定、可扩展的基础工程骨架：目录结构、编码规范、基础 Domain 模型草案、依赖策略与工具化脚本；确保后续阶段可增量演进而无需大规模重构。

## 2. 范围
- 目录与模块分布
- 基本 SwiftUI App 入口 (`BabyMeasureApp.swift` 验证)
- 初步数据模型草案（无需持久化）
- 工具脚本与格式化配置确认
- 编译与最小测试管线启动

## 3. 关键决策
| 项 | 决策 | 说明 |
|----|------|------|
| 状态管理 | SwiftUI 原生 (@State/@Observable) | 避免额外 MVVM 抽象 |
| 最小 iOS 版本 | iOS 26.0 | 对齐新 API 使用 |
| 数据持久化选择 | 优先 SwiftData (若稳定) |
| 多语言 | 字符串目录 (阶段 08 强化) | 早期保持英文占位 |
| 构建工具 | 默认 Xcode + 脚本辅助 | CI 在阶段 11 完善 |
| 代码风格 | `.swiftformat` 2 空格缩进 | 保持一致性 |

## 4. 数据与状态草案
```swift
struct ChildDraft: Identifiable {
    let id: UUID
    var name: String
    var gender: Gender?
    var birthday: Date
}

enum Gender: String, CaseIterable { case male, female, unspecified }

struct MeasurementDraft: Identifiable {
    let id: UUID
    var childId: UUID
    var type: MeasurementType
    var value: Double // 统一内部单位：身高 cm, 体重 kg, 头围 cm
    var recordedAt: Date
}

enum MeasurementType: String, CaseIterable { case height, weight, headCircumference }
```
后续阶段与数据库 Schema 对齐；这里不含百分位计算。

## 5. 接口 & 示例占位
无正式服务层；通过简单内存存储模拟：
```swift
@Observable
class InMemoryStore {
    var children: [ChildDraft] = []
    var records: [MeasurementDraft] = []

    func add(child: ChildDraft) { children.append(child) }
    func add(record: MeasurementDraft) { records.append(record) }
}
```
后续替换为 SwiftData Store，保留 API 形状以减小迁移成本。

## 6. 任务拆分
- [ ] 验证 `BabyMeasureApp.swift` 中入口配置与 Scene 结构
- [ ] 创建 `docs/phases-index.md`（已完成）
- [ ] 添加基础 Domain 草案模型文件（可在阶段 01 迁移）
- [ ] 确认 `.swiftformat` 生效（脚本 lint）
- [ ] 初始 README 扩充“技术栈”与“阶段路线”引用
- [ ] 简单脚本：`scripts/EnvCommand.swift` 验证环境变量读写

## 7. 测试与验证
| 类型 | 内容 |
|------|------|
| 编译验证 | 项目可在 iOS 26 模拟器编译运行空白视图 |
| 单元测试 | 暂时仅结构化占位 (e.g. testModelsDraftInitialization) |
| 格式化 | SwiftFormat 脚本输出无差异 |

## 8. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| SwiftData 不稳定 | 存储延迟或 API 变动 | 设计与 Core Data 兼容的抽象接口层 |
| 早期模型频繁变化 | 测试失效与重写 | 保持草案独立文件，阶段 01 后冻结基础字段 |
| iOS 26 新 API 未充分文档 | 开发迭代慢 | 渐进采用（玻璃效果在阶段 08 再加）|

## 9. 可选扩展
- 初始引入 Feature Flags（简单枚举）
- 集成 Git hooks：格式化 + 单元测试校验

## 10. 完成标准
- 项目成功在模拟器启动
- 格式化工具与脚本可运行
- 草案模型被引用无编译错误
