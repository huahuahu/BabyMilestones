import HStorage
import SwiftData
import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChildEntity.createdAt) private var children: [ChildEntity]
    @State private var selectedChildState = SelectedChildState()
    @State private var showingAddChild = false
    @State private var showingAddRecord = false
    @State private var showingExport = false

    var body: some View {
        @Bindable var state = selectedChildState
        NavigationStack {
            VStack(spacing: 0) {
                ChildHeader(selected: $state.current, children: children) { state.select($0) }
                Divider()
                if let child = state.current {
                    RecordHistoryView(child: child)
                } else {
                    ContentUnavailableView(
                        String(localized: "child.none.title"),
                        systemImage: "person.crop.circle.badge.exclam",
                        description: Text(String(localized: "child.none.description"))
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel(String(localized: "child.none.title"))
                }
            }
            .navigationTitle(String(localized: "root.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(String(localized: "export.button"), systemImage: "square.and.arrow.up") {
                        showingExport = true
                    }
                    .accessibilityLabel(String(localized: "export.button"))
                }
                ToolbarSpacer()
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if let child = state.current {
                        NavigationLink(String(localized: "root.chart.button"), destination: GrowthChartView(child: child))
                            .accessibilityLabel(String(localized: "root.chart.button"))
                    }
                    Button(String(localized: "child.add.button")) { showingAddChild = true }
                        .accessibilityLabel(String(localized: "child.add.button"))
                    Button(String(localized: "record.entry.button")) { showingAddRecord = true }
                        .buttonStyle(.glass)
                        .disabled(state.current == nil)
                        .accessibilityLabel(String(localized: "record.entry.button"))
                }
            }
            .sheet(isPresented: $showingAddChild) {
                AddChildSheet()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showingAddRecord) {
                if let child = state.current {
                    RecordEntryView(child: child)
                        .presentationDetents([.medium])
                } else {
                    Text(String(localized: "child.none.title"))
                }
            }
            .sheet(isPresented: $showingExport) {
                ExportView()
            }
            .onAppear {
                if state.current == nil {
                    state.current = children.first
                }
            }
            .onChange(of: children) {
                if state.current == nil {
                    state.current = children.first
                }
            }
            .environment(selectedChildState)
        }
    }
}

#Preview("RootView", traits: .modifier(SampleData())) {
    RootView()
}
