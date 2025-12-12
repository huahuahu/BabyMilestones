import HStorage
import SwiftData
import SwiftUI

// Access Gender definition + StorageError (same target so no extra import needed)

struct AddChildSheet: View {
  // Use SwiftData model context directly instead of an intermediate store.
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State private var name: String = ""
  @State private var birthday: Date = .now
  @State private var gender: Gender = .unspecified
  @State private var errorMessage: String?

  private var isValidName: Bool { !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
  private var isValidBirthday: Bool { birthday <= Date() }

  var body: some View {
    NavigationStack {
      Form {
        Section(String(localized: "child.info.basic")) {
          TextField(String(localized: "child.name"), text: $name)
            .accessibilityLabel(String(localized: "child.name"))
          Picker(String(localized: "child.gender"), selection: $gender) {
            ForEach(Array(Gender.allCases), id: \.self) { genderOption in
              Text(String(describing: genderOption))
            }
          }
          .accessibilityLabel(String(localized: "child.gender"))
          DatePicker(String(localized: "child.birthday"), selection: $birthday, in: ...Date(), displayedComponents: .date)
            .accessibilityLabel(String(localized: "child.birthday"))
        }
        if let errorMessage {
          Text(errorMessage)
            .foregroundStyle(.red)
            .accessibilityLabel(errorMessage)
        }
      }
      .navigationTitle(String(localized: "child.add.title"))
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(String(localized: "common.cancel"), role: .cancel) { dismiss() }
            .accessibilityLabel(String(localized: "common.cancel"))
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(String(localized: "common.save")) { save() }
            .buttonStyle(.glass)
            .disabled(!isValidName || !isValidBirthday)
            .accessibilityLabel(String(localized: "common.save"))
        }
      }
    }
  }

  private func save() {
    // Basic validation (mirrors former ChildStore logic)
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      errorMessage = String(localized: "error.name.empty")
      return
    }
    guard birthday <= Date() else {
      errorMessage = String(localized: "error.birthday.future")
      return
    }
    let child = ChildEntity(name: trimmed, genderRaw: gender == .unspecified ? nil : gender.rawValue, birthday: birthday)
    modelContext.insert(child)
    do {
      try modelContext.save()
      dismiss()
    } catch {
      // Map to a generic failure; could inspect specific errors if needed.
      errorMessage = String(localized: "error.save.failed")
    }
  }
}

#Preview("Add Child", traits: .modifier(SampleData())) {
  // Use preview trait convenience instead of manual container construction.
  AddChildSheet()
}
