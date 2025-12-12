import HStorage
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
                Section(String(localized: "record.entry.type")) {
                    Picker(String(localized: "record.entry.type"), selection: $type) {
                        ForEach(MeasurementType.allCases, id: \.self) { measurementType in
                            Text(measurementType.displayName).tag(measurementType)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel(String(localized: "record.entry.type"))
                }
                Section(String(localized: "record.entry.value")) {
                    HStack {
                        TextField(String(localized: "record.entry.value"), text: $value)
                            .keyboardType(.decimalPad)
                            .focused($focused)
                            .accessibilityLabel(String(localized: "record.entry.value"))
                        Text(type.unit).foregroundStyle(.secondary)
                    }
                    DatePicker(String(localized: "record.entry.date"), selection: $date, in: child.birthday ... Date())
                        .accessibilityLabel(String(localized: "record.entry.date"))
                }
                if let warn = rangeWarning {
                    Text(warn)
                        .font(.footnote)
                        .foregroundStyle(.orange)
                        .accessibilityLabel(warn)
                }
            }
            .navigationTitle(String(localized: "record.entry.title"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "common.cancel")) { dismiss() }
                        .accessibilityLabel(String(localized: "common.cancel"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "common.save")) { save() }
                        .buttonStyle(.glass)
                        .disabled(!isSavable)
                        .accessibilityLabel(String(localized: "common.save"))
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
            warning = String(localized: "error.record.before.birthday")
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
            warning = String(localized: "error.save.generic")
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
