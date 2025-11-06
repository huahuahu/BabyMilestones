//
//  JSONDataStoreTests.swift
//  BabyMeasureTests
//
//  Created by Copilot on 2025/11/06.
//

import Testing
import Foundation
@testable import BabyMeasure

struct JSONDataStoreTests {
  @Test
  func testSaveAndLoad() throws {
    let store = JSONDataStore()
    let testKey = "test-child-\(UUID().uuidString)"

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .male
    )

    try store.save(child, forKey: testKey)
    let loadedChild: Child? = try store.load(forKey: testKey)

    #expect(loadedChild == child)

    // Cleanup
    try store.delete(forKey: testKey)
  }

  @Test
  func testLoadNonexistentKey() throws {
    let store = JSONDataStore()
    let testKey = "nonexistent-\(UUID().uuidString)"

    let loadedChild: Child? = try store.load(forKey: testKey)
    #expect(loadedChild == nil)
  }

  @Test
  func testExists() throws {
    let store = JSONDataStore()
    let testKey = "test-exists-\(UUID().uuidString)"

    #expect(!store.exists(forKey: testKey))

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .female
    )
    try store.save(child, forKey: testKey)

    #expect(store.exists(forKey: testKey))

    try store.delete(forKey: testKey)
    #expect(!store.exists(forKey: testKey))
  }

  @Test
  func testDelete() throws {
    let store = JSONDataStore()
    let testKey = "test-delete-\(UUID().uuidString)"

    let child = Child(
      name: "Test Baby",
      birthDate: Date(),
      gender: .other
    )
    try store.save(child, forKey: testKey)
    #expect(store.exists(forKey: testKey))

    try store.delete(forKey: testKey)
    #expect(!store.exists(forKey: testKey))
  }

  @Test
  func testSaveArray() throws {
    let store = JSONDataStore()
    let testKey = "test-array-\(UUID().uuidString)"

    let children = [
      Child(name: "Child 1", birthDate: Date(), gender: .male),
      Child(name: "Child 2", birthDate: Date(), gender: .female),
    ]

    try store.save(children, forKey: testKey)
    let loadedChildren: [Child]? = try store.load(forKey: testKey)

    #expect(loadedChildren == children)

    // Cleanup
    try store.delete(forKey: testKey)
  }

  @Test
  func testOverwrite() throws {
    let store = JSONDataStore()
    let testKey = "test-overwrite-\(UUID().uuidString)"

    let child1 = Child(name: "Child 1", birthDate: Date(), gender: .male)
    try store.save(child1, forKey: testKey)

    let child2 = Child(name: "Child 2", birthDate: Date(), gender: .female)
    try store.save(child2, forKey: testKey)

    let loadedChild: Child? = try store.load(forKey: testKey)
    #expect(loadedChild == child2)
    #expect(loadedChild?.name == "Child 2")

    // Cleanup
    try store.delete(forKey: testKey)
  }
}
