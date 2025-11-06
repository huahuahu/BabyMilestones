# Phase 05 多儿童管理技术设计

## 1. 目标
支持多儿童档案管理、快速切换与数据隔离；提供编辑与删除操作的安全性与一致性。

## 2. 范围
- 档案查看与切换 UI
- 编辑档案（姓名、性别、生日、头像可选）
- 删除确认与级联删除测量记录（软删除策略评估）
- 当前选中儿童状态管理

## 3. 关键决策
| 项 | 决策 | 理由 |
|----|------|------|
| 头像存储 | 本地文件（UIImage -> Data） | 简化后续同步（阶段 06 处理）|
| 删除策略 | 直接硬删除（备份在导出中保留） | 降低复杂度 |
| 选中状态 | @State + environment injection | 避免全局单例 |

## 4. 状态模型
```swift
@Observable
class SelectedChildState {
    var current: ChildEntity?
    func select(_ child: ChildEntity) { current = child }
    func clear() { current = nil }
}
```
注入：`RootView().environment(selectedChildState)`

## 5. 档案编辑
验证：
- 名称非空
- 生日范围合理
- 性别可选
更新：调用 ChildStore.updateChild；头像保存时生成文件名 `<childId>.jpeg`。

## 6. 删除流程
1. 用户点击删除 -> 显示确认 Sheet（提示将删除所有记录）
2. 执行：MeasurementStore.recordsByChild[childId] 清理 + ChildStore.deleteChild
3. 如果删除的是 current，SelectedChildState.clear()

## 7. 任务拆分
- [ ] 实现 SelectedChildState 并接入根视图
- [ ] 档案列表增加编辑按钮
- [ ] 编辑视图 + 验证逻辑
- [ ] 头像选择（PHPicker 简化，失败回退占位）
- [ ] 删除流程与测试
- [ ] Snapshot：多儿童列表显示

## 8. 测试计划
| 测试 | 内容 |
|------|------|
| testSelectChild | 选中状态更新与通知 |
| testEditChild | 修改后字段持久化 |
| testDeleteChildCascade | 删除儿童后记录数为 0 |
| testAvatarSaveLoad | 头像写入与读取成功 |
| snapshotChildList | 多儿童显示样式 |

## 9. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| 头像文件损坏 | 崩溃或加载失败 | 使用占位图 & try? 安全读取 |
| 删除误操作 | 数据丢失 | 二次确认 + 建议导出提醒 |
| 选中状态未及时重置 | UI 不一致 | 删除后清空状态并刷新依赖视图 |

## 10. 可选扩展
- 排序（最近更新 / 名称）
- 标签或颜色标记儿童

## 11. 完成标准
- 可编辑/切换多个儿童档案
- 删除安全且记录级联清理
- 选中状态刷新正确
