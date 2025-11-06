//
//  ChildStoreTests.swift
//  BabyMeasureTests
//
//  Created by Copilot on 2025/11/06.
//

import Testing
import Foundation
@testable import BabyMeasure

// Mock persistence for testing
class MockDataStore: DataPersisting {
  var storage: [String: Data] = [:]

  func save<T: Codable>(_ data: T, forKey key: String) throws {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    storage[key] = try encoder.encode(data)
  }

  func load<T: Codable>(forKey key: String) throws -> T? {
    guard let data = storage[key] else { return nil }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: data)
  }

  func delete(forKey key: String) throws {
    storage.removeValue(forKey: key)
  }

  func exists(forKey key: String) -> Bool {
    storage[key] != nil
  }
}

@MainActor
struct ChildStoreTests {
  @Test
  func testAddChild() async {
    let mockStore = MockDataStore()
    let childStore = ChildStore(persistence: mockStore)

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .male
    )

    childStore.addChild(child)

    #expect(childStore.children.count == 1)
    #expect(childStore.children.first == child)
  }

  @Test
  func testUpdateChild() async {
    let mockStore = MockDataStore()
    let childStore = ChildStore(persistence: mockStore)

    var child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .male
    )
    childStore.addChild(child)

    child.name = "Updated Name"
    childStore.updateChild(child)

    #expect(childStore.children.first?.name == "Updated Name")
  }

  @Test
  func testDeleteChild() async {
    let mockStore = MockDataStore()
    let childStore = ChildStore(persistence: mockStore)

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .female
    )
    childStore.addChild(child)
    #expect(childStore.children.count == 1)

    childStore.deleteChild(child)
    #expect(childStore.children.isEmpty)
  }

  @Test
  func testPersistence() async {
    let mockStore = MockDataStore()
    let childStore1 = ChildStore(persistence: mockStore)

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .other
    )
    childStore1.addChild(child)

    // Create a new store instance with the same persistence
    let childStore2 = ChildStore(persistence: mockStore)

    #expect(childStore2.children.count == 1)
    #expect(childStore2.children.first == child)
  }

  @Test
  func testHasChildren() async {
    let mockStore = MockDataStore()
    let childStore = ChildStore(persistence: mockStore)

    #expect(!childStore.hasChildren)

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .male
    )
    childStore.addChild(child)

    #expect(childStore.hasChildren)
  }

  @Test
  func testChildById() async {
    let mockStore = MockDataStore()
    let childStore = ChildStore(persistence: mockStore)

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .female
    )
    childStore.addChild(child)

    let foundChild = childStore.child(withId: child.id)
    #expect(foundChild == child)

    let notFound = childStore.child(withId: UUID())
    #expect(notFound == nil)
  }
}
