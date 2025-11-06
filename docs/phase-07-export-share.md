# Phase 07 导出与分享技术设计

## 1. 目标
允许用户以 CSV / JSON 格式导出儿童与测量数据，并通过系统分享面板分享；保证数据完整性与格式规范，支持后续备份与分析。

## 2. 范围
- 导出服务：生成字符串或临时文件
- CSV 与 JSON 格式定义
- 分享 UI 集成 (ShareLink / ActivityViewController Representable)
- 选择儿童或全部导出

## 3. 格式定义
### CSV
列：`child_id,name,gender,birthday,record_id,type,value,recorded_at`（ISO8601）

### JSON
```json
{
  "version": "BabyMilestones-0.7",
  "exportedAt": "2025-11-06T10:00:00Z",
  "children": [ { "id": "...", "name": "...", "gender": "male", "birthday": "..." } ],
  "records": [ { "id": "...", "childId": "...", "type": "height", "value": 72.3, "recordedAt": "..." } ]
}
```

## 4. 接口设计
```swift
protocol Exporting {
    func exportCSV(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL
    func exportJSON(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL
}

class ExportService: Exporting {
    func exportCSV(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL { /* build + write temp */ }
    func exportJSON(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL { /* encode JSON */ }
}
```

## 5. 分享流程
1. 用户打开 ExportView
2. 选择格式与儿童范围（全部 / 单一）
3. 点击“生成” -> 调用 ExportService -> 获得 URL
4. 显示 ShareLink 或 ActivityViewController

## 6. 任务拆分
- [ ] 定义 ExportService & 协议
- [ ] CSV 转义实现（逗号/换行/双引号）
- [ ] JSON 编码（`JSONEncoder` ISO8601）
- [ ] ExportView + 选项控件
- [ ] 分享集成与临时文件清理
- [ ] 单元测试与格式快照

## 7. 测试计划
| 测试 | 内容 |
|------|------|
| testCSVBasic | 行数与列顺序正确 |
| testCSVEscaping | 特殊字符正确转义 |
| testJSONEncoding | JSON 字段与类型正确 |
| testSelectiveExport | 仅单一儿童数据包含 |
| testShareFileExists | 分享前文件存在且非空 |

## 8. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| 大文件导出耗时 | UI 冻结 | 后台 Task + 进度指示 |
| 临时文件未清理 | 占用存储 | 导出后定时清理机制 |
| 字符编码问题 | 数据无法解析 | UTF-8 明确 & 添加 BOM 可选 |

## 9. 可选扩展
- 导出加密 Zip（阶段 09 配合）
- 直接 iCloud Drive 保存

## 10. 完成标准
- CSV / JSON 导出文件格式正确
- 分享操作可用并文件可被外部打开
