import SwiftData
import SwiftUI

struct RootView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \ChildEntity.createdAt) private var children: [ChildEntity]
  @State private var selectedChild: ChildEntity?
  @State private var showingAddChild = false
  @State private var showingAddRecord = false

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        ChildHeader(selected: $selectedChild, children: children) { selectedChild = $0 }
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
        AddChildSheet()
          .presentationDetents([.medium, .large])
      }
      .sheet(isPresented: $showingAddRecord) {
        if let child = selectedChild {
          RecordEntryView(child: child)
            .presentationDetents([.medium])
        } else {
          Text("未选择儿童")
        }
      }
      .onAppear {
        if selectedChild == nil {
          selectedChild = children.first
        }
      }
      .onChange(of: children) {
        if selectedChild == nil {
          selectedChild = children.first
        }
      }
    }
  }
}

#Preview("RootView", traits: .modifier(SampleData())) {
  RootView()
}
