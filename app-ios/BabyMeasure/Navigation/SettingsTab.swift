import HStorage
import SwiftData
import SwiftUI

/// Settings tab for child management, data export, and app preferences.
struct SettingsTab: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(SelectedChildState.self) private var selectedChildState
  @Environment(AppPreferences.self) private var preferences
  @Query(sort: \ChildEntity.createdAt) private var children: [ChildEntity]

  @State private var showingAddChild = false
  @State private var showingExport = false

  var body: some View {
    NavigationStack {
      List {
        childrenSection
        AppPreferencesSection()
        dataSection
        aboutSection
      }
      .preferredColorScheme(preferences.theme.colorScheme)
      .navigationTitle("设置")
      .sheet(isPresented: $showingAddChild) {
        AddChildSheet()
          .presentationDetents([.medium, .large])
      }
      .sheet(isPresented: $showingExport) {
        ExportView()
      }
    }
  }

  // MARK: - Sections

  private var childrenSection: some View {
    Section("儿童管理") {
      ForEach(children, id: \.persistentModelID) { child in
        NavigationLink {
          EditChildView(child: child)
        } label: {
          childRow(child)
        }
      }

      Button("添加儿童", systemImage: "plus.circle") {
        showingAddChild = true
      }
    }
  }

  private var dataSection: some View {
    Section("数据") {
      Button("导出数据", systemImage: "square.and.arrow.up") {
        showingExport = true
      }
    }
  }

  private var aboutSection: some View {
    Section("关于") {
      LabeledContent("版本") {
        Text(appVersion)
      }
    }
  }

  // MARK: - Helper Views

  private func childRow(_ child: ChildEntity) -> some View {
    HStack {
      if let avatar = AvatarManager.shared.loadAvatar(for: child.id) {
        Image(uiImage: avatar)
          .resizable()
          .scaledToFill()
          .frame(width: 40, height: 40)
          .clipShape(.circle)
      } else {
        Image(systemName: "person.crop.circle.fill")
          .resizable()
          .foregroundStyle(.gray)
          .frame(width: 40, height: 40)
      }

      VStack(alignment: .leading) {
        Text(child.name)
          .font(.headline)
        Text(child.birthday, format: .dateTime.year().month().day())
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Spacer()

      if selectedChildState.current?.id == child.id {
        Image(systemName: "checkmark.circle.fill")
          .foregroundStyle(.green)
      }
    }
  }

  // MARK: - Computed Properties

  private var appVersion: String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    return "\(version) (\(build))"
  }
}

#Preview("SettingsTab", traits: .modifier(SampleData())) {
  SettingsTab()
    .environment(SelectedChildState())
    .environment(AppPreferences())
}
