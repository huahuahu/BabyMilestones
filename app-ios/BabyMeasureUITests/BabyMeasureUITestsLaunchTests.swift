//
//  BabyMeasureUITestsLaunchTests.swift
//  BabyMeasureUITests
//
//  Created by tigerguom4 on 2025/9/29.
//

import XCTest

final class BabyMeasureUITestsLaunchTests: XCTestCase {
  override static var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  @MainActor
  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
