@testable import BabyMeasure
import SwiftData
import XCTest

@MainActor
final class ChildValidationTests: XCTestCase {
  var context: ModelContext!
  var store: ChildStore!

  override func setUp() async throws {
    let container = try ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    context = ModelContext(container)
    store = ChildStore(context: context)
  }

  func testEmptyNameRejected() throws {
    XCTAssertThrowsError(try store.createChild(name: "   ", gender: nil, birthday: Date(timeIntervalSince1970: 0))) { error in
      guard let err = error as? StorageError else { return XCTFail("Wrong error type") }
      XCTAssertEqual(err, .invalidName)
    }
  }

  func testFutureBirthdayRejected() throws {
    let future = Date().addingTimeInterval(3600)
    XCTAssertThrowsError(try store.createChild(name: "Alice", gender: nil, birthday: future)) { error in
      guard let err = error as? StorageError else { return XCTFail("Wrong error type") }
      XCTAssertEqual(err, .invalidBirthday)
    }
  }

  func testTrimmedNameStored() throws {
    let child = try store.createChild(name: "  Bob  ", gender: nil, birthday: Date(timeIntervalSince1970: 0))
    XCTAssertEqual(child.name, "Bob")
  }
}
