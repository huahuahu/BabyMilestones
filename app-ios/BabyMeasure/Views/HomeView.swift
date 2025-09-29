//
//  HomeView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI
import UIKit

struct HomeView: View {
  @Environment(NavigationManager.self) private var navigation
  @Environment(DataManager.self) private var dataManager
  @State private var recentMilestones: [Milestone] = []
  @State private var upcomingMilestones: [Milestone] = []
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        // Child Profile Card
        if let currentChild = dataManager.currentChild {
          ChildProfileCard(child: currentChild)
        }
        
        // Quick Actions
        QuickActionsSection()
        
        // Recent Milestones (placeholder for now)
        VStack(alignment: .leading) {
          Text("Recent Milestones")
            .font(.headline)
          
          if recentMilestones.isEmpty {
            Text("No milestones recorded yet")
              .foregroundColor(.secondary)
          } else {
            // TODO: Add milestone list
          }
        }
        
        Spacer()
      }
      .padding()
    }
    .navigationTitle("Home")
    .navigationBarTitleDisplayMode(.large)
    .task {
      await loadHomeData()
    }
  }
  
  private func loadHomeData() async {
    // TODO: Load recent and upcoming milestones
    recentMilestones = Array(dataManager.milestones.prefix(3))
  }
}

struct ChildProfileCard: View {
  let child: Child
  @Environment(NavigationManager.self) private var navigation
  
  var body: some View {
    HStack {
      // Placeholder for child photo
      Circle()
        .fill(Color.gray.opacity(0.3))
        .frame(width: 60, height: 60)
        .overlay(
          Image(systemName: "person.fill")
            .foregroundColor(.gray)
        )
      
      VStack(alignment: .leading) {
        Text(child.name)
          .font(.title2)
          .fontWeight(.semibold)
        
        Text(child.age)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundColor(.gray)
    }
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
    .cornerRadius(12)
    .onTapGesture {
      // TODO: Navigate to child profile
    }
  }
}

struct QuickActionsSection: View {
  @Environment(NavigationManager.self) private var navigation
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Quick Actions")
        .font(.headline)
      
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
        QuickActionButton(
          icon: "plus.circle.fill",
          title: "Add Milestone",
          action: {
            navigation.navigateToAddMilestone()
          }
        )
        
        QuickActionButton(
          icon: "ruler.fill",
          title: "Record Growth",
          action: {
            navigation.navigateToAddGrowth()
          }
        )
        
        QuickActionButton(
          icon: "camera.fill",
          title: "Capture Memory",
          action: {
            navigation.navigateToAddMemory()
          }
        )
      }
    }
  }
}

struct QuickActionButton: View {
  let icon: String
  let title: String
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack {
        Image(systemName: icon)
          .font(.title2)
          .foregroundColor(.accentColor)
        Text(title)
          .font(.caption)
          .multilineTextAlignment(.center)
      }
      .frame(maxWidth: .infinity)
      .padding()
      .background(Color(UIColor.secondarySystemBackground))
      .cornerRadius(12)
    }
  }
}

#Preview {
  NavigationView {
    HomeView()
  }
  .environment(NavigationManager())
  .environment(DataManager())
}