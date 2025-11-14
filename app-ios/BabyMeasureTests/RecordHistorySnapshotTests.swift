@testable import BabyMeasure
import SwiftData
import XCTest

// Lightweight textual snapshot strategy: serialize day sections and record lines.
@MainActor
final class RecordHistorySnapshotTests: XCTestCase {
  var context: ModelContext!
  var childStore: ChildStore!
  var measurementStore: MeasurementStore!
  var child: ChildEntity!
  let calendar = Calendar.current

  override func setUp() async throws {
    let container = try ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    context = ModelContext(container)
    childStore = ChildStore(context: context)
    measurementStore = MeasurementStore(context: context)
    child = try childStore.createChild(name: "Snapshot", gender: nil, birthday: Date(timeIntervalSince1970: 0))
  }

  private func serialize(_ records: [MeasurementEntity]) -> String {
    // Group inline replicating view logic
    let buckets = Dictionary(grouping: records) { calendar.startOfDay(for: $0.recordedAt) }
    let ordered = buckets.map { ($0.key, $0.value.sorted { $0.recordedAt > $1.recordedAt }) }.sorted { $0.0 > $1.0 }
    var lines: [String] = []
    for (day, entries) in ordered {
      lines.append("# " + ISO8601DateFormatter().string(from: day))
      for e in entries {
        let type = MeasurementType(rawValue: e.typeRaw)?.rawValue ?? e.typeRaw
        lines.append("- \(type): \(String(format: "%.2f", e.value))")
      }
    }
    return lines.joined(separator: "\n") + (lines.isEmpty ? "<EMPTY>" : "")
  }

  func testSnapshotEmptyHistory() throws {
    let records = measurementStore.all(childId: child.id)
    let snapshot = serialize(records)
    XCTAssertTrue(snapshot.contains("<EMPTY>") || snapshot.isEmpty)
  }

  func testSnapshotSingleDay() throws {
    try measurementStore.addRecord(childId: child.id, type: .height, value: 80, at: Date(), childBirthday: child.birthday)
    try measurementStore.addRecord(childId: child.id, type: .weight, value: 12, at: Date().addingTimeInterval(3600), childBirthday: child.birthday)
    let snapshot = serialize(measurementStore.all(childId: child.id))
    XCTAssertEqual(snapshot.split(separator: "\n").filter { $0.hasPrefix("#") }.count, 1)
    XCTAssertTrue(snapshot.contains("height") && snapshot.contains("weight"))
  }

  func testSnapshotMultipleDays() throws {
    let day1 = Date(timeIntervalSince1970: 60 * 60 * 24 * 10)
    let day2 = day1.addingTimeInterval(60 * 60 * 24)
    try measurementStore.addRecord(childId: child.id, type: .height, value: 55, at: day1, childBirthday: child.birthday)
    try measurementStore.addRecord(childId: child.id, type: .height, value: 56, at: day2, childBirthday: child.birthday)
    let snapshot = serialize(measurementStore.all(childId: child.id))
    XCTAssertEqual(snapshot.split(separator: "\n").filter { $0.hasPrefix("#") }.count, 2)
  }
}
