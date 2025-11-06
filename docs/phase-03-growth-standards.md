# Phase 03 生长标准解析技术设计

## 1. 目标
将 /resource 中卫生部标准转换为结构化 JSON/二进制，支持后续百分位对比与图表渲染；提供插值与单位一致化能力。

## 2. 范围
- 标准原始数据提取脚本（一次性）
- 数据模型定义（百分位点 / 性别 / 年龄）
- 查询接口：给定年龄（天或月）与性别 -> 返回各百分位值
- 插值策略（若年龄不精确对应表项）

## 3. 原始数据假设
- PDF 或表格列包含：年龄（月/天）、身高 P3/P15/P50/P85/P97、体重同理、头围同理
- 按性别区分或同表内多列

## 4. 数据结构设计
```swift
struct GrowthEntry: Codable { // 单一年龄性别测量集
    let ageDays: Int // 统一转为天
    let gender: Gender // male/female
    let height: PercentileValues
    let weight: PercentileValues
    let headCircumference: PercentileValues
}

struct PercentileValues: Codable {
    let p3: Double
    let p15: Double
    let p50: Double
    let p85: Double
    let p97: Double
}

struct GrowthStandardSet: Codable {
    let version: String // e.g. "CN-MOH-2022"
    let generatedAt: Date
    let entries: [GrowthEntry] // 按 ageDays 升序
}
```

## 5. 插值策略
线性插值：在 `targetAgeDays` 不存在时，找到上下最近两个条目 `(a,b)`：
```
ratio = (target - a.ageDays) / (b.ageDays - a.ageDays)
value = aValue + ratio * (bValue - aValue)
```
边界策略：早于最小 -> 使用最小；晚于最大 -> 使用最大。

## 6. 查询接口
```swift
protocol GrowthStandardQuerying {
    func percentiles(for gender: Gender, ageDays: Int, type: MeasurementType) -> PercentileValues?
}

class GrowthStandardStore: GrowthStandardQuerying {
    private var entriesByGender: [Gender: [GrowthEntry]] = [:]

    init(jsonURL: URL) throws { /* decode & index */ }

    func percentiles(for gender: Gender, ageDays: Int, type: MeasurementType) -> PercentileValues? {
        // 1. 获取数组 2. 二分定位 3. 精确或插值 4. 返回对应字段
    }
}
```

## 7. 脚本设计 (`scripts/standards-extract.swift`)
流程：
1. 解析 PDF/表格（若 PDF 需 OCR 或手动转 CSV）
2. 统一年龄 -> 天（若原始为月：`ageDays = Int(Double(month) * 30.4375)`）
3. 构建数组并按性别分组
4. 序列化 JSON 保存到 `app-ios/BabyMeasure/Resources/GrowthStandards.json`
5. 打印统计：条目数、年龄范围、缺失行

## 8. 任务拆分
- [ ] 分析资源文件格式（可能需手动预处理）
- [ ] 编写解析脚本与转换逻辑
- [ ] 定义数据模型与 JSON Schema
- [ ] 加载与索引实现（entriesByGender）
- [ ] 插值函数与单元测试（中间值精度）
- [ ] 性能测试（1000 次查询 < 5ms 平均）

## 9. 测试计划
| 测试 | 内容 |
|------|------|
| testDecodeStandardSet | JSON 可正确解码 |
| testExactAgeLookup | 精确年龄返回正确百分位 |
| testInterpolationMidpoint | 中间年龄线性插值误差在可接受范围 |
| testBoundaryLowHigh | 低于最小 / 高于最大使用边界值 |
| testPerformanceBatchQueries | 多次随机年龄查询性能 |

## 10. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| 原始数据格式复杂 | 实现时间增加 | 先手动预处理成结构化 CSV |
| 插值误差过大 | 百分位显示偏差 | 记录误差范围，必要时使用样条插值（后期）|
| 年龄单位缺失 | 无法统一查询 | 强制转换所有年龄至天并校验范围 |

## 11. 可选扩展
- 缓存最近查询结果 (LRU)
- z-score 换算支持（需要额外公式）

## 12. 完成标准
- 成功生成标准 JSON 文件
- 查询接口在图表阶段可复用
- 插值与边界测试全部通过
