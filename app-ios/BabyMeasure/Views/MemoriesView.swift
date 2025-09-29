//
//  MemoriesView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI
import UIKit

struct MemoriesView: View {
  @Environment(NavigationManager.self) private var navigation
  @Environment(DataManager.self) private var dataManager
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 16) {
          if dataManager.memories.isEmpty {
            VStack(spacing: 20) {
              Image(systemName: "photo.on.rectangle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
              
              Text("No memories yet")
                .font(.title2)
                .fontWeight(.semibold)
              
              Text("Capture your child's precious moments")
                .foregroundColor(.secondary)
              
              Button {
                navigation.navigateToAddMemory()
              } label: {
                Text("Add First Memory")
                  .font(.headline)
                  .foregroundColor(.white)
                  .padding()
                  .background(Color.accentColor)
                  .cornerRadius(12)
              }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
          } else {
            ForEach(dataManager.memories) { memory in
              MemoryCardView(memory: memory)
            }
          }
        }
        .padding()
      }
      .navigationTitle("Memories")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            navigation.navigateToAddMemory()
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
  }
}

struct MemoryCardView: View {
  let memory: Memory
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Photo placeholder
      Rectangle()
        .fill(Color.gray.opacity(0.3))
        .frame(height: 200)
        .cornerRadius(12)
        .overlay(
          Image(systemName: "photo")
            .font(.largeTitle)
            .foregroundColor(.gray)
        )
      
      VStack(alignment: .leading, spacing: 4) {
        Text(memory.title)
          .font(.headline)
        
        if let description = memory.description {
          Text(description)
            .font(.body)
            .foregroundColor(.secondary)
        }
        
        Text(memory.date, style: .date)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
    .cornerRadius(16)
  }
}

#Preview {
  MemoriesView()
    .environment(NavigationManager())
    .environment(DataManager())
}