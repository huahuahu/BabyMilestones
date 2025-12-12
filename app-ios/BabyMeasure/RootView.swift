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
          ContentUnavailableView("未选择儿童", systemImage: "person.crop.circle.badge.exclam", description: Text("请先添加或选择儿童"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .navigationTitle("记录")
      .toolbar {
        ToolbarItemGroup(placement: .topBarLeading) {
          Button("导出", systemImage: "square.and.arrow.up") { showingExport = true }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
          if let child = state.current {
            NavigationLink("曲线", destination: GrowthChartView(child: child))
          }
          Button("添加儿童") { showingAddChild = true }
          Button("录入") { showingAddRecord = true }
            .disabled(state.current == nil)
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
          Text("未选择儿童")
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
