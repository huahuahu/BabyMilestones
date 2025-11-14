import SwiftData
import SwiftUI

struct RecordHistoryView: View {
  let child: ChildEntity
  @Environment(MeasurementStore.self)
  private var measurementStore
  @State
  private var records: [MeasurementEntity] = []
  @State
  private var grouped: [(day: Date, records: [MeasurementEntity])] = []
  @State
  private var formatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()

  var body: some View {
    Group {
      if records.isEmpty {
        ContentUnavailableView("暂无记录", systemImage: "list.bullet.circle", description: Text("添加测量以开始跟踪"))
      } else {
        content
      }
    }
    .task { load() }
    .onChange(of: child.id) { load() }
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
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(role: .destructive) { delete(rec) } label: { Label("删除", systemImage: "trash") }
            }
          }
        }
      }
    }
    .listStyle(.insetGrouped)
    .animation(.default, value: grouped.count)
  }

  private func load() {
    records = measurementStore.all(childId: child.id)
    grouped = groupMeasurementsByDay(records)
  }

  // Inline grouping logic (previously in separate file) for clarity & to avoid symbol resolution issues.
  private func groupMeasurementsByDay(_ records: [MeasurementEntity], calendar: Calendar = .current) -> [(day: Date, records: [MeasurementEntity])] {
    let buckets = Dictionary(grouping: records) { calendar.startOfDay(for: $0.recordedAt) }
    return buckets.map { ($0.key, $0.value.sorted { $0.recordedAt > $1.recordedAt }) }
      .sorted { $0.0 > $1.0 }
  }

  private func delete(_ rec: MeasurementEntity) {
    try? measurementStore.delete(record: rec)
    load()
  }
}

// MARK: - Preview

private struct RecordHistoryPreviewSeed: View {
  @Environment(\.modelContext)
  private var context
  @State
  private var child: ChildEntity?
  @State
  private var measurementStore: MeasurementStore?

  var body: some View {
    Group {
      if let child, let measurementStore {
        RecordHistoryView(child: child)
          .environment(measurementStore)
      } else {
        ProgressView().task { seed() }
      }
    }
  }

  private func seed() {
    // Create stores backed by the injected in-memory model container.
    let childStore = ChildStore(context: context)
    let measurementStore = MeasurementStore(context: context)
    // Seed sample child & measurements.
    let sampleChild = try! childStore.createChild(name: "预览宝贝", gender: String?.none, birthday: Date(timeIntervalSince1970: 0))
    try? measurementStore.addRecord(childId: sampleChild.id, type: MeasurementType.height, value: 80, at: Date(), childBirthday: sampleChild.birthday)
    try? measurementStore.addRecord(childId: sampleChild.id, type: MeasurementType.weight, value: 10, at: Date().addingTimeInterval(-3600), childBirthday: sampleChild.birthday)
    // Update state to render the actual view.
    child = sampleChild
    self.measurementStore = measurementStore
  }
}

#Preview("历史记录") {
  let container = try! ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
  RecordHistoryPreviewSeed()
    .modelContainer(container)
}
