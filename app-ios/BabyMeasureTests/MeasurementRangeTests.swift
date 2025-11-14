@testable import BabyMeasure
import SwiftData
import XCTest
import HStorage

@MainActor
final class MeasurementRangeTests: XCTestCase {
  func testRangesDefined() {
    XCTAssertEqual(MeasurementType.height.acceptableRange, 20 ... 150)
    XCTAssertEqual(MeasurementType.weight.acceptableRange, 1 ... 60)
    XCTAssertEqual(MeasurementType.headCircumference.acceptableRange, 25 ... 60)
  }

  func testOutOfRangeDetection() {
    let heightRange = MeasurementType.height.acceptableRange!
    XCTAssertFalse(heightRange.contains(10))
    XCTAssertTrue(heightRange.contains(120))
  }
}
