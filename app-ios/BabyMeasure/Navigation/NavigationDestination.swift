//
//  NavigationDestination.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import Foundation

enum NavigationDestination: Hashable {
  // Home destinations
  case childProfile(Child)
  case addChild
  case quickMilestone

  // Milestone destinations
  case milestoneCategory(MilestoneCategory)
  case milestoneDetail(Milestone)
  case addMilestone(category: MilestoneCategory?)
  case editMilestone(Milestone)

  // Growth destinations
  case growthChart(GrowthType)
  case addMeasurement(GrowthType)
  case measurementDetail(GrowthMeasurement)

  // Memory destinations
  case memoryDetail(Memory)
  case addMemory(linkedMilestone: Milestone?)
  case album(Album)
  case photoDetail(Photo)

  // Settings destinations
  case childSettings(Child)
  case notifications
  case dataPrivacy
  case appPreferences
  case help
}