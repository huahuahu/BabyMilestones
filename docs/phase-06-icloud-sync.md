# Phase 06 iCloud 同步技术设计

## 1. 目标
为用户提供可选的 iCloud 同步：在多设备间共享儿童与测量数据；保证数据一致性与冲突解决策略简单可靠；默认关闭，用户主动开启。

## 2. 范围
- 同步开关设置 UI
- 同步引擎：上传/下载/冲突合并
- 增量变更跟踪（基于时间戳）
- 离线队列缓存与重试

## 3. 关键决策
| 项 | 决策 | 理由 |
|----|------|------|
| 云框架 | CloudKit | 与 Apple 生态一致 |
| 冲突解决 | 最新 updatedAt 优先 | 简单确定性 |
| 变更粒度 | 记录级 (Child / Measurement) | 易追踪与重试 |
| 序列化 | Mirror SwiftData/CoreData 字段 | 降低转换复杂度 |

## 4. CloudKit 记录结构
| Record Type | Fields |
|-------------|--------|
| Child | id(UUID), name(String), gender(String), birthday(Date), updatedAt(Date) |
| Measurement | id(UUID), childId(UUID ref), type(String), value(Double), recordedAt(Date), updatedAt(Date) |

索引：`childId + recordedAt`；订阅通知以触发拉取。

## 5. 同步流程
1. 开启同步：本地全量扫描 -> 上传不存在或较旧项
2. 周期同步触发：
   - 前台激活
   - 手动下拉刷新
   - CloudKit 订阅推送
3. 变更合并：比较 `updatedAt`
4. 冲突：若本地与云端均有更新，取最大 `updatedAt`，另一个覆盖；保留日志（可选）

## 6. 同步引擎接口
```swift
@Observable
class SyncService {
    enum Status { case idle, syncing, error(Error) }
    var status: Status = .idle
    private let cloud: CloudKitClient
    private let childStore: ChildStore
    private let measurementStore: MeasurementStore

    func initialSync() async throws
    func syncIncremental() async
    func handlePushNotification() async
}
```

## 7. 任务拆分
- [ ] 添加设置视图 `SettingsView` + 同步开关持久化 (UserDefaults)
- [ ] CloudKit 容器与记录类型配置
- [ ] 上传基础实现 (batch save)
- [ ] 拉取更新与合并逻辑
- [ ] 冲突测试 & 重试队列
- [ ] 错误状态 UI（重试按钮）

## 8. 测试计划
| 测试 | 内容 |
|------|------|
| testEnableSyncInitialUpload | 开启后未同步项全部上传 |
| testIncrementalSync | 新增本地记录后进行增量上传 |
| testConflictResolution | 同时修改 -> 最新时间戳保留 |
| testOfflineQueue | 无网时保存队列上线后执行 |
| testDisableSyncNoFurtherCalls | 关闭后不再发起请求 |

## 9. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| CloudKit 速率限制 | 失败/延迟 | 批量分片 & 重试指数退避 |
| 冲突频繁 | 用户误解 | 提示最近一次更新时间来源 |
| 离线大量积压 | 内存增长 | 队列持久化到本地文件 |

## 10. 可选扩展
- 日志审计视图（显示最近同步操作）
- 删除同步（CloudKit 订阅删除触发本地删除）

## 11. 完成标准
- 用户可开启/关闭同步
- 多设备间创建/修改后同步成功
- 冲突按最新更新时间策略解决
