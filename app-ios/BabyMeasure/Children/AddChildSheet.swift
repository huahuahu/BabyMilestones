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
        Section("基本信息") {
          TextField("姓名", text: $name)
          Picker("性别", selection: $gender) {
            ForEach(Array(Gender.allCases), id: \.self) { genderOption in
              Text(String(describing: genderOption))
            }
          }
          DatePicker("生日", selection: $birthday, in: ...Date(), displayedComponents: .date)
        }
        if let errorMessage { Text(errorMessage).foregroundStyle(.red) }
      }
      .navigationTitle("添加儿童")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) { Button("取消", role: .cancel) { dismiss() } }
        ToolbarItem(placement: .confirmationAction) {
          Button("保存") { save() }
            .disabled(!isValidName || !isValidBirthday)
        }
      }
    }
  }

  private func save() {
    // Basic validation (mirrors former ChildStore logic)
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { errorMessage = "姓名不能为空"; return }
    guard birthday <= Date() else { errorMessage = "生日不能晚于今天"; return }
    let child = ChildEntity(name: trimmed, genderRaw: gender == .unspecified ? nil : gender.rawValue, birthday: birthday)
    modelContext.insert(child)
    do {
      try modelContext.save()
      dismiss()
    } catch {
      // Map to a generic failure; could inspect specific errors if needed.
      errorMessage = "保存失败，请检查输入"
    }
  }
}

#Preview("Add Child", traits: .modifier(SampleData())) {
  // Use preview trait convenience instead of manual container construction.
  AddChildSheet()
}
