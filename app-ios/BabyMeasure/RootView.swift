import SwiftData
import SwiftUI

struct RootView: View {
  @Environment(ChildStore.self)
  private var childStore
  @Environment(MeasurementStore.self)
  private var measurementStore
  @State
  private var selectedChild: ChildEntity?
  @State
  private var showingAddChild = false
  @State
  private var showingAddRecord = false
  @State
  private var loadError: String?

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        ChildHeader(selected: $selectedChild, children: childStore.children) { selectedChild = $0 }
        Divider()
        if let child = selectedChild {
          RecordHistoryView(child: child)
        } else {
          ContentUnavailableView("未选择儿童", systemImage: "person.crop.circle.badge.exclam", description: Text("请先添加或选择儿童"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .navigationTitle("记录")
      .toolbar {
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button("添加儿童") { showingAddChild = true }
          Button("录入") { showingAddRecord = true }
            .disabled(selectedChild == nil)
        }
      }
      .sheet(isPresented: $showingAddChild) {
        AddChildSheet(childStore: childStore)
          .presentationDetents([.medium, .large])
      }
      .sheet(isPresented: $showingAddRecord) {
        if let child = selectedChild {
          RecordEntryView(child: child, measurementStore: measurementStore)
            .presentationDetents([.medium])
        } else {
          Text("未选择儿童")
        }
      }
      .task { await loadInitial() }
      .alert("加载失败", isPresented: .constant(loadError != nil), presenting: loadError) { _ in
        Button("重试") { Task { await loadInitial() } }
      } message: { msg in Text(msg) }
    }
  }

  private func loadInitial() async {
    do {
      try await childStore.loadAll()
      if selectedChild == nil { selectedChild = childStore.children.first }
    } catch {
      loadError = "无法加载儿童列表"
    }
  }
}

#Preview {
  // Memory-only container for preview
  let container = try! ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
  let context = ModelContext(container)
  let childStore = ChildStore(context: context)
  let measurementStore = MeasurementStore(context: context)
  // Seed one child
  _ = try! childStore.createChild(name: "预览儿童", gender: nil, birthday: Date(timeIntervalSince1970: 0))
  return RootView()
    .modelContainer(container)
    .environment(childStore)
    .environment(measurementStore)
}
