import SwiftData
import SwiftUI

struct RecordEntryView: View {
  let child: ChildEntity
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State private var type: MeasurementType = .height
  @State private var value: String = ""
  @State private var date: Date = .now
  @State private var warning: String?
  @FocusState private var focused: Bool

  private var parsedValue: Double? { Double(value) }
  private var rangeWarning: String? {
    guard let val = parsedValue, let range = type.acceptableRange, !range.contains(val) else { return nil }
    return "值可能超出合理范围 (\(range.lowerBound)-\(range.upperBound) \(type.unit))"
  }

  private var isSavable: Bool { parsedValue != nil }

  var body: some View {
    NavigationStack {
      Form {
        Section("类型") {
          Picker("类型", selection: $type) {
            ForEach(MeasurementType.allCases, id: \.self) { measurementType in
              Text(measurementType.displayName).tag(measurementType)
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
      .onChange(of: value) {
        warning = rangeWarning
      }
      .task { focused = true }
    }
  }

  private func save() {
    guard let val = parsedValue else { return }
    guard date >= child.birthday else {
      warning = "记录时间不能早于生日"
      return
    }

    let record = MeasurementEntity(
      childId: child.id,
      typeRaw: type.rawValue,
      value: val,
      recordedAt: date
    )
    modelContext.insert(record)

    do {
      try modelContext.save()
      dismiss()
    } catch {
      warning = "保存失败"
    }
  }
}

// MARK: - Preview

private struct RecordEntryPreviewSeed: View {
  @Environment(\.modelContext) private var context
  @State private var child: ChildEntity?

  var body: some View {
    Group {
      if let child {
        RecordEntryView(child: child)
      } else {
        ProgressView().task { seed() }
      }
    }
  }

  private func seed() {
    let sample = ChildEntity(
      name: "预览",
      genderRaw: nil,
      birthday: Date(timeIntervalSince1970: 0)
    )
    context.insert(sample)
    try? context.save()
    child = sample
  }
}

#Preview("Record Entry", traits: .modifier(SampleData())) {
  RecordEntryPreviewSeed()
}
