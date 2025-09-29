//
//  OnboardingView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI

struct OnboardingView: View {
  @Environment(DataManager.self) private var dataManager
  
  var body: some View {
    VStack(spacing: 40) {
      Spacer()
      
      VStack(spacing: 20) {
        Image(systemName: "figure.child")
          .font(.system(size: 80))
          .foregroundColor(.accentColor)
        
        Text("Welcome to BabyMilestones")
          .font(.largeTitle)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
        
        Text("Track your child's precious moments and developmental milestones")
          .font(.title3)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
      
      Spacer()
      
      Button {
        dataManager.completeOnboarding()
      } label: {
        Text("Get Started")
          .font(.headline)
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.accentColor)
          .cornerRadius(12)
      }
      .padding(.horizontal, 40)
      .padding(.bottom, 50)
    }
    .padding()
  }
}

#Preview {
  OnboardingView()
    .environment(DataManager())
}