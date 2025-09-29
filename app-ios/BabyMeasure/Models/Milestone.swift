//
//  Milestone.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import Foundation

struct Milestone: Identifiable, Hashable, Codable {
  let id: UUID
  var title: String
  var description: String
  var category: MilestoneCategory
  var ageRange: AgeRange
  var isAchieved: Bool
  var achievedDate: Date?
  var notes: String?
  
  init(title: String, description: String, category: MilestoneCategory, ageRange: AgeRange) {
    self.id = UUID()
    self.title = title
    self.description = description
    self.category = category
    self.ageRange = ageRange
    self.isAchieved = false
  }
}

struct MilestoneCategory: Identifiable, Hashable, Codable {
  let id: UUID
  var name: String
  var icon: String
  var color: String
  
  init(name: String, icon: String, color: String) {
    self.id = UUID()
    self.name = name
    self.icon = icon
    self.color = color
  }
}

struct AgeRange: Hashable, Codable {
  var minMonths: Int
  var maxMonths: Int
  
  var description: String {
    if minMonths == maxMonths {
      return "\(minMonths) month\(minMonths == 1 ? "" : "s")"
    }
    return "\(minMonths)-\(maxMonths) months"
  }
}