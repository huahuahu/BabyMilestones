//
//  ChildDraft.swift
//  BabyMeasure
//
//  Phase 00: Foundation - Draft model for child data
//  Will be migrated to SwiftData in Phase 01
//

import Foundation

struct ChildDraft: Identifiable, Codable {
  let id: UUID
  var name: String
  var gender: Gender?
  var birthday: Date

  init(
    id: UUID = UUID(),
    name: String,
    gender: Gender? = nil,
    birthday: Date
  ) {
    self.id = id
    self.name = name
    self.gender = gender
    self.birthday = birthday
  }
}
