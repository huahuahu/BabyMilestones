//
//  AppTab.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI

enum AppTab: String, CaseIterable {
  case home = "house.fill"
  case milestones = "list.clipboard.fill"
  case growth = "chart.line.uptrend.xyaxis"
  case memories = "photo.fill"
  case settings = "gear"

  var title: String {
    switch self {
    case .home: return "Home"
    case .milestones: return "Milestones"
    case .growth: return "Growth"
    case .memories: return "Memories"
    case .settings: return "Settings"
    }
  }
}