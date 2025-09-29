//
//  PlaceholderViews.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI
import UIKit

// MARK: - Placeholder Views for Navigation Destinations

struct ChildProfileView: View {
  let child: Child
  
  var body: some View {
    VStack {
      Text("Child Profile")
        .font(.largeTitle)
      Text(child.name)
        .font(.title)
      Text("Age: \(child.age)")
        .font(.headline)
    }
    .navigationTitle("Profile")
  }
}

struct AddChildView: View {
  var body: some View {
    VStack {
      Text("Add Child")
        .font(.largeTitle)
      Text("Coming Soon")
        .foregroundColor(.secondary)
    }
    .navigationTitle("Add Child")
  }
}

struct MilestoneDetailView: View {
  let milestone: Milestone
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Text(milestone.title)
          .font(.largeTitle)
          .fontWeight(.bold)
        
        Text(milestone.description)
          .font(.body)
        
        VStack(alignment: .leading, spacing: 8) {
          Text("Age Range")
            .font(.headline)
          Text(milestone.ageRange.description)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
        }
        
        VStack(alignment: .leading, spacing: 8) {
          Text("Status")
            .font(.headline)
          HStack {
            Image(systemName: milestone.isAchieved ? "checkmark.circle.fill" : "circle")
              .foregroundColor(milestone.isAchieved ? .green : .gray)
            Text(milestone.isAchieved ? "Achieved" : "Not yet achieved")
          }
        }
        
        if let notes = milestone.notes {
          VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
              .font(.headline)
            Text(notes)
              .padding()
              .background(Color(UIColor.secondarySystemBackground))
              .cornerRadius(8)
          }
        }
        
        Spacer()
      }
      .padding()
    }
    .navigationTitle("Milestone")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct AddMilestoneView: View {
  let category: MilestoneCategory?
  
  var body: some View {
    VStack {
      Text("Add Milestone")
        .font(.largeTitle)
      if let category = category {
        Text("Category: \(category.name)")
          .font(.headline)
      }
      Text("Coming Soon")
        .foregroundColor(.secondary)
    }
    .navigationTitle("Add Milestone")
  }
}

#Preview("Child Profile") {
  NavigationView {
    ChildProfileView(child: Child(name: "Emma", birthDate: Date()))
  }
}

#Preview("Milestone Detail") {
  NavigationView {
    MilestoneDetailView(milestone: Milestone(
      title: "First Smile",
      description: "Baby smiles in response to your smile",
      category: MilestoneCategory(name: "Social", icon: "face.smiling", color: "blue"),
      ageRange: AgeRange(minMonths: 2, maxMonths: 3)
    ))
  }
}