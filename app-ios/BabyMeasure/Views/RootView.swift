//
//  RootView.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import SwiftUI

struct RootView: View {
  @StateObject private var childStore = ChildStore()
  @StateObject private var growthStore = GrowthStore()
  @State private var showOnboarding = false

  var body: some View {
    Group {
      if childStore.hasChildren {
        MainView()
      } else {
        Color.clear
          .onAppear {
            showOnboarding = true
          }
      }
    }
    .environmentObject(childStore)
    .environmentObject(growthStore)
    .sheet(isPresented: $showOnboarding) {
      OnboardingView()
    }
  }
}

struct MainView: View {
  @EnvironmentObject var childStore: ChildStore
  @EnvironmentObject var growthStore: GrowthStore

  var body: some View {
    NavigationStack {
      List {
        ForEach(childStore.children) { child in
          NavigationLink(destination: ChildDetailView(child: child)) {
            VStack(alignment: .leading) {
              Text(child.name)
                .font(.headline)
              Text("Age: \(child.ageInMonths(at: Date())) months")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
          }
        }
      }
      .navigationTitle("Children")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(destination: AddChildView()) {
            Image(systemName: "plus")
          }
        }
      }
    }
  }
}

struct ChildDetailView: View {
  let child: Child
  @EnvironmentObject var growthStore: GrowthStore

  var body: some View {
    List {
      Section("Information") {
        HStack {
          Text("Name")
          Spacer()
          Text(child.name)
        }

        HStack {
          Text("Birth Date")
          Spacer()
          Text(child.birthDate, style: .date)
        }

        HStack {
          Text("Age")
          Spacer()
          Text("\(child.ageInMonths(at: Date())) months (\(child.ageInDays(at: Date())) days)")
        }

        HStack {
          Text("Gender")
          Spacer()
          Text(child.gender.rawValue.capitalized)
        }
      }

      Section("Measurements") {
        let measurements = growthStore.measurements(forChildId: child.id)
        if measurements.isEmpty {
          Text("No measurements yet")
            .foregroundColor(.secondary)
        } else {
          ForEach(measurements) { measurement in
            HStack {
              VStack(alignment: .leading) {
                Text(measurement.type.displayName)
                  .font(.headline)
                Text(measurement.measuredAt, style: .date)
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
              Spacer()
              Text("\(measurement.value, specifier: "%.1f") \(measurement.unit.symbol)")
                .font(.body)
            }
          }
        }

        NavigationLink(destination: AddMeasurementView(childId: child.id)) {
          Label("Add Measurement", systemImage: "plus")
        }
      }
    }
    .navigationTitle(child.name)
  }
}

struct AddChildView: View {
  @EnvironmentObject var childStore: ChildStore
  @State private var childName = ""
  @State private var birthDate = Date()
  @State private var selectedGender = Child.Gender.male
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    Form {
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
    .navigationTitle("Add Child")
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

struct AddMeasurementView: View {
  let childId: UUID
  @EnvironmentObject var growthStore: GrowthStore
  @State private var selectedType = GrowthMeasurement.MeasurementType.height
  @State private var value = ""
  @State private var selectedUnit = GrowthMeasurement.MeasurementUnit.centimeters
  @State private var measuredDate = Date()
  @State private var notes = ""
  @State private var showValidationError = false
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    Form {
      Section("Measurement Details") {
        Picker("Type", selection: $selectedType) {
          ForEach(GrowthMeasurement.MeasurementType.allCases, id: \.self) { type in
            Text(type.displayName).tag(type)
          }
        }
        .onChange(of: selectedType) { _, newType in
          updateDefaultUnit(for: newType)
        }

        HStack {
          TextField("Value", text: $value)
            .keyboardType(.decimalPad)

          Picker("Unit", selection: $selectedUnit) {
            ForEach(availableUnits, id: \.self) { unit in
              Text(unit.symbol).tag(unit)
            }
          }
          .pickerStyle(.menu)
        }

        DatePicker(
          "Measured Date",
          selection: $measuredDate,
          in: ...Date(),
          displayedComponents: [.date]
        )
      }

      Section("Notes (Optional)") {
        TextEditor(text: $notes)
          .frame(height: 100)
      }

      Section {
        Button(action: addMeasurement) {
          HStack {
            Spacer()
            Text("Add Measurement")
              .fontWeight(.semibold)
            Spacer()
          }
        }
        .disabled(value.isEmpty)
      }
    }
    .navigationTitle("Add Measurement")
    .alert("Invalid Measurement", isPresented: $showValidationError) {
      Button("OK", role: .cancel) {}
    } message: {
      Text("The measurement value is outside the valid range. Please check and try again.")
    }
    .onAppear {
      updateDefaultUnit(for: selectedType)
    }
  }

  private var availableUnits: [GrowthMeasurement.MeasurementUnit] {
    switch selectedType {
    case .height:
      return [.centimeters, .inches]
    case .weight:
      return [.kilograms, .grams, .pounds]
    case .headCircumference:
      return [.centimeters, .inches]
    }
  }

  private func updateDefaultUnit(for type: GrowthMeasurement.MeasurementType) {
    switch type {
    case .height:
      selectedUnit = .centimeters
    case .weight:
      selectedUnit = .kilograms
    case .headCircumference:
      selectedUnit = .centimeters
    }
  }

  private func addMeasurement() {
    guard let numericValue = Double(value) else { return }

    let measurement = GrowthMeasurement(
      childId: childId,
      type: selectedType,
      value: numericValue,
      unit: selectedUnit,
      measuredAt: measuredDate,
      notes: notes.isEmpty ? nil : notes
    )

    // Validate the measurement
    guard measurement.isValid() else {
      showValidationError = true
      return
    }

    growthStore.addMeasurement(measurement)
    dismiss()
  }
}

#Preview {
  RootView()
}
