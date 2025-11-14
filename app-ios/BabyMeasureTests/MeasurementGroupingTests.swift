@testable import BabyMeasure
import SwiftData
import XCTest

final class MeasurementGroupingTests: XCTestCase {
  var context: ModelContext!
  var childStore: ChildStore!
  var measurementStore: MeasurementStore!
  var child: ChildEntity!

  override func setUp() async throws {
    let container = try ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    context = ModelContext(container)
    childStore = ChildStore(context: context)
    measurementStore = MeasurementStore(context: context)
    child = try childStore.createChild(name: "Test", gender: nil, birthday: Date(timeIntervalSince1970: 0))
  }

  func testGroupingSameDay() throws {
    let now = Date()
    try measurementStore.addRecord(childId: child.id, type: .height, value: 50, at: now, childBirthday: child.birthday)
    try measurementStore.addRecord(childId: child.id, type: .weight, value: 5, at: now.addingTimeInterval(3600), childBirthday: child.birthday)
    let all = measurementStore.all(childId: child.id)
    let grouped = Dictionary(grouping: all) { Calendar.current.startOfDay(for: $0.recordedAt) }
    XCTAssertEqual(grouped.count, 1)
  }

  func testGroupingDifferentDays() throws {
    let day1 = Date(timeIntervalSince1970: 60 * 60 * 24 * 10)
    let day2 = day1.addingTimeInterval(60 * 60 * 24)
    try measurementStore.addRecord(childId: child.id, type: .height, value: 55, at: day1, childBirthday: child.birthday)
    try measurementStore.addRecord(childId: child.id, type: .height, value: 56, at: day2, childBirthday: child.birthday)
    let all = measurementStore.all(childId: child.id)
    let grouped = Dictionary(grouping: all) { Calendar.current.startOfDay(for: $0.recordedAt) }
    XCTAssertEqual(grouped.count, 2)
  }
}
