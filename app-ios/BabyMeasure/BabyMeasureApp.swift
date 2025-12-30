//
//  BabyMeasureApp.swift
//  BabyMeasure
//
//  Created by tigerguom4 on 2025/9/29.
//
import HStorage
import SwiftData
import SwiftUI

@main
struct BabyMeasureApp: App {
  /// The storage mode read at app launch.
  /// Changes to this setting require an app restart to take effect.
  private let storageMode: StorageMode = {
    if let rawValue = UserDefaults.standard.string(forKey: "app.preferences.storageMode"),
       let mode = StorageMode(rawValue: rawValue)
    {
      return mode
    }
    return .iCloud
  }()

  var body: some Scene {
    WindowGroup {
      RootView()
        .modelContainer(HContainer.container(for: storageMode))
    }
  }
}
