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
  @State private var cloudStatus = CloudAccountStatus()

  var body: some View {
    NavigationStack {
      List {
        if cloudStatus.shouldShowWarning(for: preferences.storageMode) {
          iCloudWarningSection
        }
        childrenSection
        AppPreferencesSection()
        dataSection
        aboutSection
        #if DEBUG
          debugSection
        #endif
      }
      .preferredColorScheme(preferences.theme.colorScheme)
      .navigationTitle("tab.settings")
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

  private var iCloudWarningSection: some View {
    Section {
      Label {
        VStack(alignment: .leading) {
          Text("settings.icloud.warning.title")
            .font(.headline)
          Text(cloudStatus.statusMessage)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      } icon: {
        Image(systemName: "exclamationmark.icloud.fill")
          .foregroundStyle(.orange)
      }

      Button("settings.icloud.warning.openSettings", systemImage: "gear") {
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url)
        }
      }
    }
  }

  private var childrenSection: some View {
    Section("settings.children.section") {
      ForEach(children, id: \.persistentModelID) { child in
        NavigationLink {
          EditChildView(child: child)
        } label: {
          childRow(child)
        }
      }

      Button("settings.children.add", systemImage: "plus.circle") {
        showingAddChild = true
      }
    }
  }

  private var dataSection: some View {
    Section("settings.data.section") {
      Button("settings.data.export", systemImage: "square.and.arrow.up") {
        showingExport = true
      }
    }
  }

  private var aboutSection: some View {
    Section("settings.about.section") {
      LabeledContent("settings.about.version") {
        Text(appVersion)
      }
    }
  }

  #if DEBUG
    private var debugSection: some View {
      @Bindable var preferences = preferences

      return Section {
        Picker("settings.storage.mode", selection: $preferences.storageMode) {
          ForEach(StorageMode.allCases) { mode in
            Text(mode.displayName)
              .tag(mode)
          }
        }

        Text("settings.storage.restart.hint")
          .font(.caption)
          .foregroundStyle(.secondary)
      } header: {
        Label("settings.debug.section", systemImage: "hammer")
      }
    }
  #endif

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
          .foregroundStyle(Color.accentColor)
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
