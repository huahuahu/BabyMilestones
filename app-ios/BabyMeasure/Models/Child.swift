//
//  Child.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import Foundation

struct Child: Identifiable, Codable, Equatable {
  let id: UUID
  var name: String
  var birthDate: Date
  var gender: Gender
  var createdAt: Date
  var updatedAt: Date

  enum Gender: String, Codable, CaseIterable {
    case male
    case female
    case other
  }

  init(
    id: UUID = UUID(),
    name: String,
    birthDate: Date,
    gender: Gender,
    createdAt: Date = Date(),
    updatedAt: Date = Date()
  ) {
    self.id = id
    self.name = name
    self.birthDate = birthDate
    self.gender = gender
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }

  /// Calculate age in months from birth date
  func ageInMonths(at date: Date = Date()) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month], from: birthDate, to: date)
    return components.month ?? 0
  }

  /// Calculate age in days from birth date
  func ageInDays(at date: Date = Date()) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: birthDate, to: date)
    return components.day ?? 0
  }
}
