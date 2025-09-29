//
//  DataManager.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import Foundation

@Observable
class DataManager {
  var currentChild: Child?
  var children: [Child] = []
  var milestones: [Milestone] = []
  var growthMeasurements: [GrowthMeasurement] = []
  var memories: [Memory] = []
  var albums: [Album] = []
  
  var hasCompletedOnboarding: Bool {
    UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
  }
  
  init() {
    loadData()
  }
  
  func setCurrentChild(_ child: Child) {
    currentChild = child
    if !children.contains(where: { $0.id == child.id }) {
      children.append(child)
    }
    saveData()
  }
  
  func completeOnboarding() {
    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
  }
  
  func checkOnboardingStatus() {
    // This method can be used to perform additional checks if needed
  }
  
  private func loadData() {
    // TODO: Implement data loading from persistent storage
    // For now, create sample data for development
    createSampleData()
  }
  
  private func saveData() {
    // TODO: Implement data saving to persistent storage
  }
  
  private func createSampleData() {
    let sampleChild = Child(
      name: "Emma",
      birthDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
    )
    
    let physicalCategory = MilestoneCategory(
      name: "Physical Development",
      icon: "figure.walk",
      color: "blue"
    )
    
    let cognitiveCategory = MilestoneCategory(
      name: "Cognitive Development",
      icon: "brain.head.profile",
      color: "purple"
    )
    
    let sampleMilestones = [
      Milestone(
        title: "First Smile",
        description: "Baby smiles in response to your smile",
        category: physicalCategory,
        ageRange: AgeRange(minMonths: 2, maxMonths: 3)
      ),
      Milestone(
        title: "Sits Without Support",
        description: "Baby can sit upright without any support",
        category: physicalCategory,
        ageRange: AgeRange(minMonths: 4, maxMonths: 7)
      ),
      Milestone(
        title: "Responds to Name",
        description: "Baby turns head when you call their name",
        category: cognitiveCategory,
        ageRange: AgeRange(minMonths: 6, maxMonths: 9)
      )
    ]
    
    if hasCompletedOnboarding {
      currentChild = sampleChild
      children = [sampleChild]
      milestones = sampleMilestones
    }
  }
}