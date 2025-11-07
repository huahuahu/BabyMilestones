//
//  ContentView.swift
//  BabyMeasure
//
//  Created by tigerguom4 on 2025/9/29.
//

import SwiftUI

struct ContentView: View {
  // Access the shared in-memory draft store injected at the App level.
  @Environment(InMemoryStore.self)
  private var store
  @State
  private var showAddSample = false

  var body: some View {
    NavigationStack {
      VStack(spacing: 16) {
        if store.children.isEmpty {
          ContentUnavailableView("No Children Yet", systemImage: "person.crop.circle.badge.questionmark", description: Text("Add a sample child to start tracking."))
        } else {
          List(store.children) { child in
            VStack(alignment: .leading) {
              Text(child.name).font(.headline)
              Text(child.birthday, format: .dateTime.year().month().day()).font(.caption).foregroundStyle(.secondary)
            }
          }
          .listStyle(.plain)
        }

        Button(action: addSampleChild) {
          Label("Add Sample Child", systemImage: "plus")
        }
        .buttonStyle(.borderedProminent)
        .accessibilityIdentifier("addSampleChild")
      }
      .padding()
      .navigationTitle("BabyMilestones")
    }
  }

  private func addSampleChild() {
    let draft = ChildDraft(
      id: UUID(),
      name: "Sample",
      gender: .unspecified,
      birthday: .now
    )
    store.add(child: draft)
  }
}

#Preview {
  ContentView()
    .environment(InMemoryStore())
}
