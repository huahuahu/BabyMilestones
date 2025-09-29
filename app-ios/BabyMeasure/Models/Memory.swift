//
//  Memory.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import Foundation

struct Memory: Identifiable, Hashable, Codable {
  let id: UUID
  var title: String
  var description: String?
  var date: Date
  var photoData: Data?
  var videoURL: URL?
  var linkedMilestoneId: UUID?
  
  init(title: String, description: String? = nil, date: Date, photoData: Data? = nil, videoURL: URL? = nil, linkedMilestoneId: UUID? = nil) {
    self.id = UUID()
    self.title = title
    self.description = description
    self.date = date
    self.photoData = photoData
    self.videoURL = videoURL
    self.linkedMilestoneId = linkedMilestoneId
  }
}

struct Album: Identifiable, Hashable, Codable {
  let id: UUID
  var name: String
  var memoryIds: [UUID]
  var coverPhotoData: Data?
  
  init(name: String, memoryIds: [UUID] = [], coverPhotoData: Data? = nil) {
    self.id = UUID()
    self.name = name
    self.memoryIds = memoryIds
    self.coverPhotoData = coverPhotoData
  }
}

struct Photo: Identifiable, Hashable, Codable {
  let id: UUID
  var data: Data
  var caption: String?
  var date: Date
  
  init(data: Data, caption: String? = nil, date: Date = Date()) {
    self.id = UUID()
    self.data = data
    self.caption = caption
    self.date = date
  }
}