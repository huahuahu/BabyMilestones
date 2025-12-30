import HStorage
import SwiftData
import SwiftUI

/// Home tab displaying growth charts and quick actions for measurement entry.
struct HomeTab: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(SelectedChildState.self) private var selectedChildState
  @Query(sort: \ChildEntity.createdAt) private var children: [ChildEntity]

  @State private var showingAddRecord = false

  var body: some View {
    @Bindable var state = selectedChildState
    NavigationStack {
      Group {
        if let child = state.current {
          GrowthChartView(child: child)
        } else {
          emptyState
        }
      }
      .navigationTitle(Text(state.current?.name ?? "tab.home"))
      .toolbar {
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button("record.entry.button", systemImage: "plus.circle") { showingAddRecord = true }
            .disabled(state.current == nil)
        }
      }
      .sheet(isPresented: $showingAddRecord) {
        if let child = state.current {
          RecordEntryView(child: child)
            .presentationDetents([.medium])
        }
      }
      .onAppear { initializeSelection() }
      .onChange(of: children) { initializeSelection() }
    }
  }

  private var emptyState: some View {
    ContentUnavailableView(
      "child.none.title",
      systemImage: "person.crop.circle.badge.exclam",
      description: Text("child.none.description")
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func initializeSelection() {
    if selectedChildState.current == nil {
      selectedChildState.current = children.first
    }
  }
}

#Preview("HomeTab", traits: .modifier(SampleData())) {
  HomeTab()
    .environment(SelectedChildState())
}
