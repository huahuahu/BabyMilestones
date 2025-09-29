//
//  SettingsView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI

struct SettingsView: View {
  @Environment(DataManager.self) private var dataManager
  
  var body: some View {
    NavigationView {
      List {
        Section("Child Profile") {
          if let currentChild = dataManager.currentChild {
            HStack {
              Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                  Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                )
              
              VStack(alignment: .leading) {
                Text(currentChild.name)
                  .font(.headline)
                Text(currentChild.age)
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
              
              Spacer()
              
              Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
            }
          } else {
            HStack {
              Image(systemName: "plus.circle.fill")
                .foregroundColor(.accentColor)
              Text("Add Child Profile")
            }
          }
        }
        
        Section("Preferences") {
          HStack {
            Image(systemName: "bell")
              .foregroundColor(.orange)
            Text("Notifications")
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundColor(.gray)
              .font(.caption)
          }
          
          HStack {
            Image(systemName: "ruler")
              .foregroundColor(.blue)
            Text("Units")
            Spacer()
            Text("Metric")
              .foregroundColor(.secondary)
            Image(systemName: "chevron.right")
              .foregroundColor(.gray)
              .font(.caption)
          }
        }
        
        Section("Data") {
          HStack {
            Image(systemName: "square.and.arrow.up")
              .foregroundColor(.green)
            Text("Export Data")
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundColor(.gray)
              .font(.caption)
          }
          
          HStack {
            Image(systemName: "shield")
              .foregroundColor(.purple)
            Text("Privacy")
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundColor(.gray)
              .font(.caption)
          }
        }
        
        Section("Support") {
          HStack {
            Image(systemName: "questionmark.circle")
              .foregroundColor(.gray)
            Text("Help & FAQ")
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundColor(.gray)
              .font(.caption)
          }
          
          HStack {
            Image(systemName: "info.circle")
              .foregroundColor(.gray)
            Text("About")
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundColor(.gray)
              .font(.caption)
          }
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

#Preview {
  SettingsView()
    .environment(DataManager())
}