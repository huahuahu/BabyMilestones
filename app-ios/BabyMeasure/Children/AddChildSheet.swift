import SwiftData
import SwiftUI

// Access Gender & StorageError definitions
// (They reside in same target so no module import needed.)

struct AddChildSheet: View {
  // Inject store explicitly from parent to avoid environment resolution issues during migration phase.
  let childStore: ChildStore
  @Environment(\.dismiss)
  private var dismiss

  @State
  private var name: String = ""
  @State
  private var birthday: Date = .now
  @State
  private var gender: Gender = .unspecified
  @State
  private var errorMessage: String?

  private var isValidName: Bool { !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
  private var isValidBirthday: Bool { birthday <= Date() }

  var body: some View {
    NavigationStack {
      Form {
        Section("基本信息") {
          TextField("姓名", text: $name)
          Picker("性别", selection: $gender) {
            ForEach(Array(Gender.allCases), id: \.self) { g in
              Text(String(describing: g))
            }
          }
          DatePicker("生日", selection: $birthday, in: ...Date(), displayedComponents: .date)
        }
        if let errorMessage {
          Text(errorMessage).foregroundStyle(.red)
        }
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
    do {
      _ = try childStore.createChild(name: name, gender: gender == .unspecified ? nil : gender.rawValue, birthday: birthday)
      dismiss()
    } catch let err as StorageError {
      switch err {
      case .invalidName: errorMessage = "姓名不能为空"
      case .invalidBirthday: errorMessage = "生日不能晚于今天"
      default: errorMessage = "保存失败，请检查输入"
      }
    } catch {
      errorMessage = "保存失败，请检查输入"
    }
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State
    private var store: ChildStore
    init() {
      let container = try! ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
      let context = ModelContext(container)
      _store = State(initialValue: ChildStore(context: context))
    }

    var body: some View { AddChildSheet(childStore: store) }
  }
  return PreviewWrapper()
}
