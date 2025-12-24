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
            .navigationTitle("tab.growth")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("export.button", systemImage: "square.and.arrow.up") { showingExport = true }
                }
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
            .sheet(isPresented: $showingExport) {
                ExportView()
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

#Preview("GrowthTab", traits: .modifier(SampleData())) {
    GrowthTab()
        .environment(SelectedChildState())
}
