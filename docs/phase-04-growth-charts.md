# Phase 04 生长曲线图表技术设计

## 1. 目标
在图表中直观展示儿童记录与生长标准百分位曲线对比（身高/体重/头围），支持平滑表现、切换类型与基本交互；保证性能与可读性。

## 2. 范围
- 使用 Swift Charts (若可用) 绘制多条百分位线与散点
- 支持类型切换与时间范围缩放（最近 3 月 / 全部 / 自定义）
- 性能优化（大量点时抽稀）
- 空数据与极端值处理

## 3. 关键决策
| 项 | 决策 | 理由 |
|----|------|------|
| 绘图库 | Swift Charts | 原生、易组合与交互支持 |
| 抽稀策略 | Douglas-Peucker 或简单步进抽样 | 控制线条点数 < 300 |
| 百分位选择 | P3/P10/p25/P50/P75/p90/P97 | 覆盖常用区间 |
| 动画 | 初始淡入 + 切换类型过渡 | 保持视觉连贯 |

## 4. 数据准备流程
1. 获取用户记录按时间排序 -> 转年龄天数
2. 对于百分位线：预生成 AgeDays 列表（步长根据范围动态：<= 180 天用 5 天步长，否则 15 天）
3. 调用 GrowthStandardStore.percentiles -> 构建线对象
4. 抽稀：若点数 > 阈值进行简化

## 5. 视图结构
```swift
struct GrowthChartView: View {
    @Environment(MeasurementStore.self) private var measurementStore
    @Environment(GrowthStandardStore.self) private var standardStore
    let child: ChildEntity
    @State private var selectedType: MeasurementType = .height
    @State private var range: ChartRange = .recent3Months

    var body: some View {
        VStack {
            Chart { chartContent }
                .chartOverlay { interactiveOverlay }
            typePicker
            rangePicker
        }
        .task { prepareData() }
    }
}
```

## 6. 抽稀示例
```swift
func simplify(_ points: [ChartPoint], max: Int) -> [ChartPoint] {
    guard points.count > max else { return points }
    let step = Double(points.count) / Double(max)
    return stride(from: 0.0, to: Double(points.count), by: step).map { points[Int($0)] }
}
```

## 7. 测试与验证
| 测试 | 内容 |
|------|------|
| testChartDataMapping | 记录转年龄与值映射正确 |
| testPercentileLinesCount | 不同范围生成点数合理 |
| testSimplifyFunction | 抽稀后保留趋势（首尾与中间）|
| snapshotBasicChart | 基础视图渲染对比基准 |
| snapshotNoRecords | 空态显示占位文案 |

## 8. 性能指标
- 加载数据准备 < 150ms（最近 3 月）
- 全范围线点数控制 < 300
- 滚动/缩放交互保持 60fps（估测）

## 9. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| 百分位插值过慢 | 初次进入延迟 | 提前缓存 Range 内标准查询结果 |
| 点数过多造成卡顿 | 掉帧 | 抽稀 + 分段加载 |
| 极端值远离主图 | 视觉不聚焦 | 自动扩展 y 轴范围并显示提示标识 |

## 10. 可选扩展
- Long-press tooltip 显示具体百分位与用户值
- 多儿童对比（叠加散点）
- 平滑曲线（样条）开关

## 11. 完成标准
- 可以切换三种测量类型
- 曲线与散点正确渲染
- 性能符合指标无明显卡顿
