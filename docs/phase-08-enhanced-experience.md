# Phase 08 高级体验与 iOS 26 增强技术设计

## 1. 目标
引入 iOS 26 新增 UI 能力（玻璃效果、滚动边缘效果），加强辅助功能与国际化体验，提升整体视觉与可访问性质量。

## 2. 范围
- glassEffect 与 buttonStyle(.glass) 在关键操作区域应用
- scrollEdgeEffectStyle 优化长列表感知
- VoiceOver 标签与 Dynamic Type 支持
- 初步中英文本地化（Strings Catalog）
- 高对比度与深色模式检查

## 3. 视觉增强策略
| 区域 | 效果 | 说明 |
|------|------|------|
| 主操作按钮（录入、导出） | `.buttonStyle(.glass)` | 突出主 CTA |
| 图表背景 | `.glassEffect(.thin, in: .rect(cornerRadius:12))` | 现代感 |
| 顶部工具栏分隔 | `ToolbarSpacer()` | 视觉节奏 |

## 4. 辅助功能
- 所有图标添加 `accessibilityLabel`
- 图表点通过聚合描述（“最近 30 天共有 12 条记录，高度均值 72.3 cm”）
- Dynamic Type：使用 `font(.body)` 等级，不硬编码字号

## 5. 国际化
Strings Catalog: `Localizable.xcstrings`
键命名：`child.add.button`, `record.entry.title`, `export.share.description`
中文初始翻译 + 英文默认。

## 6. 任务拆分
- [ ] 添加 Strings Catalog 并替换硬编码文案
- [ ] 关键按钮应用 glass 效果
- [ ] 图表与列表滚动边缘效果设置
- [ ] VoiceOver 标签与可访问性审查
- [ ] 深色模式下对比度校验（使用系统颜色）

## 7. 测试计划
| 测试 | 内容 |
|------|------|
| testLocalizationFallback | 未翻译 key 使用英文 |
| testAccessibilityLabels | 关键视图标签非空 |
| snapshotGlassEffect | 主要按钮与图表背景视觉基准 |
| dynamicTypeLarge | 超大字体布局未截断 |

## 8. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| 玻璃效果过度影响性能 | 滚动掉帧 | 控制应用区域 + Instruments 检测 |
| 未覆盖全部文案 | 体验不一致 | 建立 lint 脚本扫描硬编码字符串 |
| VoiceOver 描述冗长 | 可访问性体验差 | 精简为关键信息 |

## 9. 可选扩展
- 自适应 TabBar 最小化行为 (`tabBarMinimizeBehavior`) 后期加入
- HDR 颜色在图表百分位线应用

## 10. 完成标准
- 主要 UI 已应用增强效果且性能正常
- 本地化覆盖主流程文案
- 辅助功能检查通过（无关键缺失标签）
