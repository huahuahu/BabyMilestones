//
//  ChildTests.swift
//  BabyMeasureTests
//
//  Created by Copilot on 2025/11/06.
//

import Testing
import Foundation
@testable import BabyMeasure

struct ChildTests {
  @Test
  func testChildCreation() {
    let birthDate = Date(timeIntervalSince1970: 1577836800)  // 2020-01-01
    let child = Child(
      name: "Test Baby",
      birthDate: birthDate,
      gender: .male
    )

    #expect(child.name == "Test Baby")
    #expect(child.birthDate == birthDate)
    #expect(child.gender == .male)
    #expect(child.id != UUID())  // Should have a unique ID
  }

  @Test
  func testAgeCalculationInMonths() {
    // Create a child born 12 months ago
    let calendar = Calendar.current
    let birthDate = calendar.date(byAdding: .month, value: -12, to: Date())!
    let child = Child(
      name: "Test Baby",
      birthDate: birthDate,
      gender: .female
    )

    let age = child.ageInMonths()
    #expect(age == 12)
  }

  @Test
  func testAgeCalculationInDays() {
    // Create a child born 30 days ago
    let calendar = Calendar.current
    let birthDate = calendar.date(byAdding: .day, value: -30, to: Date())!
    let child = Child(
      name: "Test Baby",
      birthDate: birthDate,
      gender: .other
    )

    let age = child.ageInDays()
    #expect(age == 30)
  }

  @Test
  func testChildEquality() {
    let id = UUID()
    let birthDate = Date()
    let child1 = Child(
      id: id,
      name: "Test Baby",
      birthDate: birthDate,
      gender: .male
    )
    let child2 = Child(
      id: id,
      name: "Test Baby",
      birthDate: birthDate,
      gender: .male
    )

    #expect(child1 == child2)
  }

  @Test
  func testChildCodable() throws {
    let birthDate = Date(timeIntervalSince1970: 1577836800)
    let child = Child(
      name: "Test Baby",
      birthDate: birthDate,
      gender: .female
    )

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let data = try encoder.encode(child)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedChild = try decoder.decode(Child.self, from: data)

    #expect(decodedChild == child)
  }
}
