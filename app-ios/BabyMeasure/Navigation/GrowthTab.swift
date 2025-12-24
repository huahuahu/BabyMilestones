import HStorage
import SwiftData
import SwiftUI

/// Growth tab displaying measurement history and export options.
struct GrowthTab: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(SelectedChildState.self) private var selectedChildState
  @Query(sort: \ChildEntity.createdAt) private var children: [ChildEntity]

  @State private var showingAddRecord = false
  @State private var showingExport = false

  var body: some View {
    @Bindable var state = selectedChildState
    NavigationStack {
      Group {
        if let child = state.current {
          RecordHistoryView(child: child)
        } else {
          emptyState
        }
      }
      .navigationTitle("记录")
      .toolbar {
        ToolbarItemGroup(placement: .topBarLeading) {
          Button("导出", systemImage: "square.and.arrow.up") { showingExport = true }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button("录入", systemImage: "plus.circle") { showingAddRecord = true }
            .disabled(state.current == nil)
        }
      }
      .sheet(isPresented: $showingAddRecord) {
        if let child = state.current {
          RecordEntryView(child: child)
            .presentationDetents([.medium])
        }
      }
      .sheet(isPresented: $showingExport) {
        ExportView()
      }
      .onAppear { initializeSelection() }
      .onChange(of: children) { initializeSelection() }
    }
  }

  private var emptyState: some View {
    ContentUnavailableView(
      "未选择儿童",
      systemImage: "person.crop.circle.badge.exclam",
      description: Text("请先添加或选择儿童")
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func initializeSelection() {
    if selectedChildState.current == nil {
      selectedChildState.current = children.first
    }
  }
}

#Preview("GrowthTab", traits: .modifier(SampleData())) {
  GrowthTab()
    .environment(SelectedChildState())
}
