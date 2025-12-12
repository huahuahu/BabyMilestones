import Foundation
import SwiftData

@Model
public class ChildEntity {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var genderRaw: String?
    public var birthday: Date
    public var createdAt: Date
    public var updatedAt: Date

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
    @Attribute(.unique) public var id: UUID
    public var childId: UUID
    public var typeRaw: String // height|weight|headCircumference
    public var value: Double
    public var recordedAt: Date
    public var createdAt: Date

    public init(id: UUID = UUID(), childId: UUID, typeRaw: String, value: Double, recordedAt: Date, createdAt: Date = Date()) {
        self.id = id
        self.childId = childId
        self.typeRaw = typeRaw
        self.value = value
        self.recordedAt = recordedAt
        self.createdAt = createdAt
    }
}
