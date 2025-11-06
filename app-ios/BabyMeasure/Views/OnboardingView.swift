//
//  OnboardingView.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import SwiftUI

struct OnboardingView: View {
  @EnvironmentObject var childStore: ChildStore
  @State private var childName = ""
  @State private var birthDate = Date()
  @State private var selectedGender = Child.Gender.male
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      Form {
        Section {
          VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to BabyMeasure")
              .font(.title)
              .fontWeight(.bold)
            Text("Let's start by adding your first child")
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
          .padding(.vertical)
        }

        Section("Child Information") {
          TextField("Child's Name", text: $childName)

          DatePicker(
            "Birth Date",
            selection: $birthDate,
            in: ...Date(),
            displayedComponents: [.date]
          )

          Picker("Gender", selection: $selectedGender) {
            ForEach(Child.Gender.allCases, id: \.self) { gender in
              Text(gender.rawValue.capitalized).tag(gender)
            }
          }
        }

        Section {
          Button(action: addChild) {
            HStack {
              Spacer()
              Text("Add Child")
                .fontWeight(.semibold)
              Spacer()
            }
          }
          .disabled(childName.isEmpty)
        }
      }
      .navigationTitle("Get Started")
    }
  }

  private func addChild() {
    let newChild = Child(
      name: childName,
      birthDate: birthDate,
      gender: selectedGender
    )
    childStore.addChild(newChild)
    dismiss()
  }
}

#Preview {
  OnboardingView()
    .environmentObject(ChildStore())
}
