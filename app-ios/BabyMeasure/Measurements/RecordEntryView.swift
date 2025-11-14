import SwiftData
import SwiftUI

struct RecordEntryView: View {
  let child: ChildEntity
  let measurementStore: MeasurementStore
  @Environment(\.dismiss)
  private var dismiss

  @State
  private var type: MeasurementType = .height
  @State
  private var value: String = ""
  @State
  private var date: Date = .now
  @State
  private var warning: String?
  @FocusState
  private var focused: Bool

  private var parsedValue: Double? { Double(value) }
  private var rangeWarning: String? {
    guard let v = parsedValue, let range = type.acceptableRange, !range.contains(v) else { return nil }
    return "值可能超出合理范围 (\(range.lowerBound)-\(range.upperBound) \(type.unit))"
  }

  private var isSavable: Bool { parsedValue != nil }

  var body: some View {
    NavigationStack {
      Form {
        Section("类型") {
          Picker("类型", selection: $type) {
            ForEach(MeasurementType.allCases, id: \.self) { t in
              Text(t.displayName).tag(t)
            }
          }
          .pickerStyle(.segmented)
        }
        Section("数值") {
          HStack {
            TextField("数值", text: $value)
              .keyboardType(.decimalPad)
              .focused($focused)
            Text(type.unit).foregroundStyle(.secondary)
          }
          DatePicker("时间", selection: $date, in: child.birthday ... Date())
        }
        if let warn = rangeWarning {
          Text(warn).font(.footnote).foregroundStyle(.orange)
        }
      }
      .navigationTitle("新建记录")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }
        ToolbarItem(placement: .confirmationAction) {
          Button("保存") { save() }.disabled(!isSavable)
        }
      }
      .onChange(of: value) { _ in warning = rangeWarning }
      .task { focused = true }
    }
  }

  private func save() {
    guard let v = parsedValue else { return }
    do {
      try measurementStore.addRecord(childId: child.id, type: type, value: v, at: date, childBirthday: child.birthday)
      dismiss()
    } catch {
      warning = "保存失败"
    }
  }
}

#Preview {
  let container = try! ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
  let context = ModelContext(container)
  let childStore = ChildStore(context: context)
  let measurementStore = MeasurementStore(context: context)
  let child = try! childStore.createChild(name: "预览", gender: nil, birthday: Date(timeIntervalSince1970: 0))
  return RecordEntryView(child: child, measurementStore: measurementStore)
    .modelContainer(container)
    .environment(childStore)
    .environment(measurementStore)
}
