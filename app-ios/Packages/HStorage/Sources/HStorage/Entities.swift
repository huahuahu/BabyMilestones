import Foundation
import SwiftData

// Note: @Attribute(.unique) removed for CloudKit compatibility.
// CloudKit does not support unique constraints.

@Model
public class ChildEntity {
  public var id: UUID = UUID()
  public var name: String = ""
  public var genderRaw: String?
  public var birthday: Date = Date()
  public var createdAt: Date = Date()
  public var updatedAt: Date = Date()

  public init(id: UUID = UUID(), name: String, genderRaw: String? = nil, birthday: Date, createdAt: Date = Date(), updatedAt: Date = Date()) {
    self.id = id
    self.name = name
    self.genderRaw = genderRaw
    self.birthday = birthday
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

@Model
public class MeasurementEntity {
  public var id: UUID = UUID()
  public var childId: UUID = UUID()
  public var typeRaw: String = "" // height|weight|headCircumference
  public var value: Double = 0.0
  public var recordedAt: Date = Date()
  public var createdAt: Date = Date()

  public init(id: UUID = UUID(), childId: UUID, typeRaw: String, value: Double, recordedAt: Date, createdAt: Date = Date()) {
    self.id = id
    self.childId = childId
    self.typeRaw = typeRaw
    self.value = value
    self.recordedAt = recordedAt
    self.createdAt = createdAt
  }
}
