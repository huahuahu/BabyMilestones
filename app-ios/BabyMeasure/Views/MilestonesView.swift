//
//  MilestonesView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI

struct MilestonesView: View {
  @Environment(NavigationManager.self) private var navigation
  @Environment(DataManager.self) private var dataManager
  @State private var searchText = ""
  
  var body: some View {
    NavigationView {
      List {
        ForEach(filteredMilestones) { milestone in
          NavigationLink(value: NavigationDestination.milestoneDetail(milestone)) {
            MilestoneRowView(milestone: milestone)
          }
        }
      }
      .navigationTitle("Milestones")
      .navigationBarTitleDisplayMode(.large)
      .searchable(text: $searchText)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            navigation.navigateToAddMilestone()
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
  }
  
  private var filteredMilestones: [Milestone] {
    if searchText.isEmpty {
      return dataManager.milestones
    } else {
      return dataManager.milestones.filter { milestone in
        milestone.title.localizedCaseInsensitiveContains(searchText) ||
        milestone.description.localizedCaseInsensitiveContains(searchText)
      }
    }
  }
}

struct MilestoneRowView: View {
  let milestone: Milestone
  
  var body: some View {
    HStack {
      Image(systemName: milestone.isAchieved ? "checkmark.circle.fill" : "circle")
        .foregroundColor(milestone.isAchieved ? .green : .gray)
        .font(.title2)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(milestone.title)
          .font(.headline)
        
        Text(milestone.description)
          .font(.caption)
          .foregroundColor(.secondary)
          .lineLimit(2)
        
        Text(milestone.ageRange.description)
          .font(.caption2)
          .padding(.horizontal, 8)
          .padding(.vertical, 2)
          .background(Color.accentColor.opacity(0.2))
          .cornerRadius(4)
      }
      
      Spacer()
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  MilestonesView()
    .environment(NavigationManager())
    .environment(DataManager())
}