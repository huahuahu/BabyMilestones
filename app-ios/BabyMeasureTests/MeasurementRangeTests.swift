@testable import BabyMeasure
import HStorage
import SwiftData
import XCTest

@MainActor
final class MeasurementRangeTests: XCTestCase {
    func testRangesDefined() {
        XCTAssertEqual(MeasurementType.height.acceptableRange, 20 ... 150)
        XCTAssertEqual(MeasurementType.weight.acceptableRange, 1 ... 60)
        XCTAssertEqual(MeasurementType.headCircumference.acceptableRange, 25 ... 60)
    }

    func testOutOfRangeDetection() throws {
        let heightRange = try XCTUnwrap(MeasurementType.height.acceptableRange)
        XCTAssertFalse(heightRange.contains(10))
        XCTAssertTrue(heightRange.contains(120))
    }
}
