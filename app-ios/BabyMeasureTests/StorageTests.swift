@testable import BabyMeasure
import SwiftData
import XCTest

@MainActor
final class StorageTests: XCTestCase {
  var context: ModelContext!
  var childStore: ChildStore!
  var measurementStore: MeasurementStore!

  override func setUp() async throws {
    let container = try ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    context = ModelContext(container)
    childStore = ChildStore(context: context)
    measurementStore = MeasurementStore(context: context)
  }

  func testCreateChild() throws {
    let child = try childStore.createChild(name: "Alice", gender: "F", birthday: Date(timeIntervalSince1970: 0))
    XCTAssertEqual(child.name, "Alice")
    XCTAssertEqual(child.genderRaw, "F")
  }

  func testInvalidBirthday() throws {
    let future = Date().addingTimeInterval(60 * 60 * 24)
    XCTAssertThrowsError(try childStore.createChild(name: "Bob", gender: nil, birthday: future))
  }

  func testAddMeasurement() throws {
    let child = try childStore.createChild(name: "C", gender: nil, birthday: Date(timeIntervalSince1970: 0))
    try measurementStore.addRecord(childId: child.id, type: .height, value: 80.0, at: Date(), childBirthday: child.birthday)
    let latest = measurementStore.latest(childId: child.id, type: .height)
    XCTAssertEqual(latest.count, 1)
    XCTAssertEqual(latest.first?.value, 80.0)
  }

  //    func testPerformanceBulkInsert() throws {
  //        let child = try childStore.createChild(name: "Perf", gender: nil, birthday: Date(timeIntervalSince1970: 0))
  //        measure {
  //            for i in 0..<1000 {
  //                try? measurementStore.addRecord(childId: child.id, type: .weight, value: Double(i), at: Date().addingTimeInterval(Double(i)), childBirthday: child.birthday)
  //            }
  //            let all = measurementStore.all(childId: child.id)
  //            let allCount = all.count
  //            print("all count \(all.count)")
  //            XCTAssertEqual(allCount, 1000)
  //        }
  //    }
}
