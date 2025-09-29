//
//  Child.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import Foundation

struct Child: Identifiable, Hashable, Codable {
  let id: UUID
  var name: String
  var birthDate: Date
  var photoData: Data?
  
  init(name: String, birthDate: Date, photoData: Data? = nil) {
    self.id = UUID()
    self.name = name
    self.birthDate = birthDate
    self.photoData = photoData
  }

  var age: String {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: birthDate, to: Date())
    
    if let years = components.year, years > 0 {
      return "\(years) year\(years == 1 ? "" : "s")"
    } else if let months = components.month, months > 0 {
      return "\(months) month\(months == 1 ? "" : "s")"
    } else if let days = components.day {
      return "\(days) day\(days == 1 ? "" : "s")"
    }
    return "Newborn"
  }
}