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
    @State private var errorMessage: LocalizedStringKey?

    private var isValidName: Bool { !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    private var isValidBirthday: Bool { birthday <= Date() }

    var body: some View {
        NavigationStack {
            Form {
                Section("child.info.basic") {
                    TextField("child.name", text: $name)
                        .accessibilityLabel(Text("child.name"))
                    Picker("child.gender", selection: $gender) {
                        ForEach(Array(Gender.allCases), id: \.self) { genderOption in
                            Text(String(describing: genderOption))
                        }
                    }
                    .accessibilityLabel(Text("child.gender"))
                    DatePicker("child.birthday", selection: $birthday, in: ...Date(), displayedComponents: .date)
                        .accessibilityLabel(Text("child.birthday"))
                }
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .accessibilityLabel(Text(errorMessage))
                }
            }
            .navigationTitle("child.add.title")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel", role: .cancel) { dismiss() }
                        .accessibilityLabel(Text("common.cancel"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") { save() }
                        .buttonStyle(.glass)
                        .disabled(!isValidName || !isValidBirthday)
                        .accessibilityLabel(Text("common.save"))
                }
            }
        }
    }

    private func save() {
        // Basic validation (mirrors former ChildStore logic)
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "error.name.empty"
            return
        }
        guard birthday <= Date() else {
            errorMessage = "error.birthday.future"
            return
        }
        let child = ChildEntity(name: trimmed, genderRaw: gender == .unspecified ? nil : gender.rawValue, birthday: birthday)
        modelContext.insert(child)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            // Map to a generic failure; could inspect specific errors if needed.
            errorMessage = "error.save.failed"
        }
    }
}

#Preview("Add Child", traits: .modifier(SampleData())) {
    // Use preview trait convenience instead of manual container construction.
    AddChildSheet()
}
