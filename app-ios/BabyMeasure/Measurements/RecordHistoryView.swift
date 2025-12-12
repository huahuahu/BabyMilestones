import HStorage
import SwiftData
import SwiftUI

struct RecordHistoryView: View {
  let child: ChildEntity

  @Environment(\.modelContext) private var modelContext
  @Query private var allRecords: [MeasurementEntity]
  @State private var grouped: [(day: Date, records: [MeasurementEntity])] = []
  @State private var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  private var records: [MeasurementEntity] {
    allRecords.filter { $0.childId == child.id }
  }

  var body: some View {
    Group {
      if records.isEmpty {
        ContentUnavailableView(
          String(localized: "history.empty.title"), 
          systemImage: "list.bullet.circle", 
          description: Text(String(localized: "history.empty.description"))
        )
        .accessibilityLabel(String(localized: "history.empty.title"))
      } else {
        content
      }
    }
    .onAppear { updateGrouped() }
    .onChange(of: allRecords) { updateGrouped() }
    .onChange(of: child.id) { updateGrouped() }
  }

  private var content: some View {
    List {
      ForEach(grouped, id: \.day) { section in
        Section(formatter.string(from: section.day)) {
          ForEach(section.records, id: \.persistentModelID) { rec in
            // Break complex Text concatenation into smaller subviews to help the compiler type-check quickly.
            let measurementType = MeasurementType(rawValue: rec.typeRaw)
            let typeName = measurementType?.displayName ?? rec.typeRaw
            let unit = measurementType?.unit ?? ""
            let valueString = String(format: "%.2f", rec.value)
            HStack(alignment: .firstTextBaseline, spacing: 8) {
              Text(typeName)
              Spacer()
              HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(valueString)
                Text(unit)
                  .foregroundStyle(.secondary)
              }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(typeName) \(valueString) \(unit)")
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(role: .destructive) { delete(rec) } label: { 
                Label(String(localized: "record.delete"), systemImage: "trash") 
              }
              .accessibilityLabel(String(localized: "record.delete"))
            }
          }
        }
      }
    }
    .listStyle(.insetGrouped)
    .animation(.default, value: grouped.count)
  }

  private func updateGrouped() {
    grouped = groupMeasurementsByDay(records)
  }

  // Inline grouping logic (previously in separate file) for clarity & to avoid symbol resolution issues.
  private func groupMeasurementsByDay(_ records: [MeasurementEntity], calendar: Calendar = .current) -> [(day: Date, records: [MeasurementEntity])] {
    let buckets = Dictionary(grouping: records) { calendar.startOfDay(for: $0.recordedAt) }
    return buckets.map { ($0.key, $0.value.sorted { $0.recordedAt > $1.recordedAt }) }
      .sorted { $0.0 > $1.0 }
  }

  private func delete(_ rec: MeasurementEntity) {
    modelContext.delete(rec)
    try? modelContext.save()
  }
}

// MARK: - Preview

private struct RecordHistoryPreviewSeed: View {
  @Environment(\.modelContext) private var context
  @State private var child: ChildEntity?

  var body: some View {
    Group {
      if let child {
        RecordHistoryView(child: child)
      } else {
        ProgressView().task { seed() }
      }
    }
  }

  private func seed() {
    // Create sample child
    let sampleChild = ChildEntity(
      name: "预览宝贝",
      genderRaw: nil,
      birthday: Date(timeIntervalSince1970: 0)
    )
    context.insert(sampleChild)

    // Create sample measurements
    let heightRecord = MeasurementEntity(
      childId: sampleChild.id,
      typeRaw: MeasurementType.height.rawValue,
      value: 80,
      recordedAt: Date()
    )
    context.insert(heightRecord)

    let weightRecord = MeasurementEntity(
      childId: sampleChild.id,
      typeRaw: MeasurementType.weight.rawValue,
      value: 10,
      recordedAt: Date().addingTimeInterval(-3600)
    )
    context.insert(weightRecord)

    try? context.save()
    child = sampleChild
  }
}

#Preview("历史记录", traits: .modifier(SampleData())) {
  RecordHistoryPreviewSeed()
}
