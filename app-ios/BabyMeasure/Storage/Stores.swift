import Foundation
import Observation
import SwiftData

public enum StorageError: Error {
  case duplicateRecord
  case invalidBirthday
  case notFound
}

@Observable
public class ChildStore {
  private let context: ModelContext
  public private(set) var children: [ChildEntity] = []

  public init(context: ModelContext) {
    self.context = context
  }

  public func loadAll() async throws {
    let descriptor = FetchDescriptor<ChildEntity>(sortBy: [SortDescriptor(\.createdAt)])
    let result = try context.fetch(descriptor)
    await MainActor.run { self.children = result }
  }

  public func createChild(name: String, gender: String?, birthday: Date) throws -> ChildEntity {
    guard birthday <= Date() else { throw StorageError.invalidBirthday }
    let child = ChildEntity(name: name, genderRaw: gender, birthday: birthday)
    context.insert(child)
    try context.save()
    return child
  }

  public func updateChild(_ child: ChildEntity, mutate: (ChildEntity) -> Void) throws {
    mutate(child)
    child.updatedAt = Date()
    try context.save()
  }

  public func deleteChild(_ child: ChildEntity) throws {
    context.delete(child)
    try context.save()
  }
}

@Observable
public class MeasurementStore {
  private let context: ModelContext
  public private(set) var recordsByChild: [UUID: [MeasurementEntity]] = [:]

  public init(context: ModelContext) {
    self.context = context
  }

  public func addRecord(childId: UUID, type: MeasurementType, value: Double, at date: Date, childBirthday: Date) throws {
    guard date >= childBirthday else { throw StorageError.invalidBirthday }
    let record = MeasurementEntity(childId: childId, typeRaw: type.rawValue, value: value, recordedAt: date)
    context.insert(record)
    try context.save()
  }

  public func latest(childId: UUID, type: MeasurementType, limit: Int = 10) -> [MeasurementEntity] {
    var descriptor = FetchDescriptor<MeasurementEntity>(
      predicate: #Predicate { $0.childId == childId && $0.typeRaw == type.rawValue },
      sortBy: [SortDescriptor(\.recordedAt, order: .reverse)]
    )
    descriptor.fetchLimit = limit
    return (try? context.fetch(descriptor)) ?? []
  }

  public func all(childId: UUID) -> [MeasurementEntity] {
    let descriptor = FetchDescriptor<MeasurementEntity>(
      predicate: #Predicate { $0.childId == childId },
      sortBy: [SortDescriptor(\.recordedAt, order: .reverse)]
    )
    return (try? context.fetch(descriptor)) ?? []
  }

  public func delete(record: MeasurementEntity) throws {
    context.delete(record)
    try context.save()
  }
}
