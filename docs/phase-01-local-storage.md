# Phase 01 本地存储层技术设计

## 1. 目标
提供可靠的本地持久化：儿童与测量记录 CRUD、查询与排序；为后续标准匹配与图表提供数据基础。可离线工作并支持未来 iCloud 增量扩展。

## 2. 范围
- Schema 定义（SwiftData 优先，兼容 Core Data）
- 基础存储访问 API + @Observable Store
- 索引与查询性能初步设计
- 简单数据校验（生日不能晚于今天等）

## 3. 关键决策
| 项 | 决策 | 理由 |
|----|------|------|
| 框架 | SwiftData 若可用；否则 Core Data | 减少样板代码并拥抱新特性 |
| ID 类型 | UUID（稳定） | 易序列化与跨设备同步 |
| 时间戳 | Date (UTC) | 统一时区，显示时本地化 |
| 单位存储 | 统一内部单位（cm/kg/cm） | 避免重复换算与误差 |
| 数据访问模式 | 专用 Store 对象注入 environment | 保持 SwiftUI 原生流 |

## 4. 数据模型 Schema
```swift
@Model
class ChildEntity { // 若 SwiftData
    @Attribute(.unique) var id: UUID
    var name: String
    var genderRaw: String?
    var birthday: Date
    var createdAt: Date
    var updatedAt: Date
}

@Model
class MeasurementEntity {
    @Attribute(.unique) var id: UUID
    var childId: UUID
    var typeRaw: String // height|weight|headCircumference
    var value: Double
    var recordedAt: Date
    var createdAt: Date
}
```
索引建议：`childId + recordedAt`（查询历史排序）、`typeRaw + childId`（图表某类型筛选）。

Core Data 兼容：生成等价实体 + NSPredicate 查询。

## 5. 状态与服务接口
```swift
enum MeasurementType: String { case height, weight, headCircumference }

enum StorageError: Error { case duplicateRecord, invalidBirthday, notFound }

@Observable
class ChildStore {
    private let context: ModelContext // 或 NSManagedObjectContext
    @Published private(set) var children: [ChildEntity] = []

    func loadAll() async throws { /* fetch & assign */ }
    func createChild(name: String, gender: Gender?, birthday: Date) throws -> ChildEntity { /* validate */ }
    func updateChild(_ child: ChildEntity, mutate: (ChildEntity) -> Void) throws
    func deleteChild(_ child: ChildEntity) throws
}

@Observable
class MeasurementStore {
    private let context: ModelContext
    @Published private(set) var recordsByChild: [UUID: [MeasurementEntity]] = [:]

    func addRecord(childId: UUID, type: MeasurementType, value: Double, at date: Date) throws
    func latest(childId: UUID, type: MeasurementType, limit: Int = 10) -> [MeasurementEntity]
    func all(childId: UUID) -> [MeasurementEntity]
    func delete(record: MeasurementEntity) throws
}
```

## 6. 验证与校验
- 生日不得晚于当前日期
- 记录时间戳不得早于儿童生日
- 同一儿童同一时间（recordedAt 精确到分钟）同一类型可避免重复（可选）

## 7. 任务拆分
- [ ] 选择 SwiftData 或回退 Core Data（运行环境检查）
- [ ] 定义实体与迁移策略占位（版本号 1）
- [ ] 实现 ChildStore / MeasurementStore 基础 API
- [ ] 添加单元测试：创建、查询、删除、排序
- [ ] 添加简单数据量性能测试（1000 条记录加载 < 200ms 目标）

## 8. 测试设计
| 测试 | 内容 |
|------|------|
| testCreateChild | 名称/生日创建成功 |
| testInvalidBirthday | 未来生日抛错 |
| testAddMeasurement | 正常插入并出现在查询中 |
| testDuplicateRecordOptional | 重复记录拦截（若启用策略） |
| testPerformanceBulkInsert | 1k 插入时间与内存占用 |

## 9. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| SwiftData Beta 行为变化 | 迁移失败 | 设计兼容层：抽象协议 StorageAdapter |
| 索引缺失导致查询慢 | 图表加载延迟 | 基准测试 + 添加 FetchDescriptor sort |
| 大量写入阻塞 UI | 卡顿 | 使用 Task { @MainActor 更新 } 后台批量写入 |

## 10. 可选扩展
- 增量缓存（基于 childId 的 in-memory 索引）
- Measurement 去重哈希 (childId+type+roundedTime)

## 11. 完成标准
- 实体编译通过并可运行基本 CRUD
- 单元测试全部通过
- 记录加载性能达标
