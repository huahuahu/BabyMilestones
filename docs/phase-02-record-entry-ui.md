# Phase 02 录入与列表 UI 技术设计

## 1. 目标
实现最小可用交互：添加儿童、添加测量记录、浏览记录历史；建立可复用组件与一致状态流模式，为后续图表与同步提供入口。

## 2. 范围
- `ChildListView` / `AddChildSheet`
- `RecordEntryView`（快速录入）
- `RecordHistoryView`（分组显示）
- 基础导航结构（Tab 或 Stack）

## 3. 关键决策
| 项 | 决策 | 理由 |
|----|------|------|
| 导航 | 单 Tab 起步（"记录"），后续扩展多 Tab | 降低早期复杂度 |
| 录入方式 | Sheet + Inline 快速按钮 | 减少层级跳转 |
| 分组策略 | Daily Section (recordedAt 日期) | 用户心理模型贴合日常观察 |
| 状态传递 | environment 注入 Stores | 避免全局单例 |

## 4. 视图与状态结构
```swift
struct RootView: View {
    @Environment(ChildStore.self) private var childStore
    @Environment(MeasurementStore.self) private var measurementStore
    @State private var selectedChild: ChildEntity?
    @State private var showingAddChild = false
    @State private var showingAddRecord = false

    var body: some View {
        NavigationStack {
            VStack {
                ChildHeader(selected: $selectedChild)
                RecordHistoryView(child: selectedChild)
            }
            .toolbar {
                Button("添加儿童") { showingAddChild = true }
                Button("录入") { showingAddRecord = true }.disabled(selectedChild == nil)
            }
            .sheet(isPresented: $showingAddChild) { AddChildSheet() }
            .sheet(isPresented: $showingAddRecord) { RecordEntryView(child: selectedChild) }
        }
    }
}
```

## 5. 组件设计
| 组件 | 说明 | 交互 |
|------|------|------|
| ChildHeader | 当前儿童信息 + 切换下拉 | 切换更新 selectedChild |
| AddChildSheet | 表单：姓名/生日/性别 | 验证后调用 childStore.createChild |
| RecordEntryView | 类型选择 + 数值输入 + 时间 | 验证后 measurementStore.addRecord |
| RecordHistoryView | SectionList (date) | 展示记录，支持删除 |

## 6. 输入校验
- 名称非空（去除前后空格）
- 生日 <= 今天
- 测量值：
  - 身高 20–150 cm（暂定）
  - 体重 1–60 kg
  - 头围 25–60 cm
  超出范围提示“请确认”。

## 7. 任务拆分
- [ ] 创建基础组件文件划分 (`Milestones/` 或 `Children/` 分组)
- [ ] 实现 `AddChildSheet` 表单校验
- [ ] 实现 `RecordEntryView` 三种类型统一布局
- [ ] `RecordHistoryView` 分组逻辑（formatter 提前缓存）
- [ ] 删除记录操作（滑动删除）
- [ ] Snapshot 测试：空历史 / 有记录 / 多 Section

## 8. 测试计划
| 测试 | 内容 |
|------|------|
| testAddChildValidation | 空名称与未来生日拒绝 |
| testAddRecordRanges | 极端值提示 | 
| testHistoryGrouping | 同一天记录在同一 Section |
| snapshotEmptyHistory | 无记录视图占位一致 |
| snapshotMultipleSections | 多日期渲染对比基准 |

## 9. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| 录入频繁状态刷新 | UI 卡顿 | 使用局部 @State 避免全量刷新 |
| 日期格式化性能 | 列表滚动抖动 | 预构建 DateFormatter cache |
| 删除动画不一致 | 用户体验差 | 使用 `.animation(.default, value: ...)` 保持一致 |

## 10. 可选扩展
- 最近一次记录快捷按钮
- 快速单位切换（内部统一存储，显示转换）

## 11. 完成标准
- 可添加/切换儿童
- 可录入三类测量并在历史中显示
- 删除操作生效且数据刷新正确
