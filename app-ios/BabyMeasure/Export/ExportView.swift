import HStorage
import SwiftData
import SwiftUI

/// View for exporting child and measurement data.
struct ExportView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @Query(sort: \ChildEntity.createdAt) private var allChildren: [ChildEntity]

  @State private var exportFormat: ExportFormat = .csv
  @State private var exportScope: ExportScope = .all
  @State private var selectedChildId: UUID?
  @State private var exportState: ExportState = .idle
  @State private var exportedFileURL: URL?

  private let exportService = ExportService()

  var body: some View {
    NavigationStack {
      Form {
        formatSection
        scopeSection
        exportButtonSection
      }
      .navigationTitle("export.title")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("common.cancel") { dismiss() }
            .accessibilityLabel(Text("common.cancel"))
        }
      }
    }
  }

  // MARK: - Sections

  private var formatSection: some View {
    Section {
      Picker("export.format", selection: $exportFormat) {
        ForEach(ExportFormat.allCases) { format in
          Text(format.displayName).tag(format)
        }
      }
      .pickerStyle(.segmented)
      .accessibilityLabel(Text("export.format"))
    } header: {
      Text("export.format.section")
    } footer: {
      Text(exportFormat.descriptionKey)
    }
  }

  private var scopeSection: some View {
    Section("export.scope") {
      Picker("export.scope", selection: $exportScope) {
        Text("export.scope.all").tag(ExportScope.all)
        Text("export.scope.single").tag(ExportScope.single)
      }
      .pickerStyle(.segmented)
      .accessibilityLabel(Text("export.scope"))

      if exportScope == .single {
        if allChildren.isEmpty {
          Text("no.children.data")
            .foregroundStyle(.secondary)
        } else {
          Picker("export.select.child", selection: $selectedChildId) {
            Text("export.select.placeholder").tag(nil as UUID?)
            ForEach(allChildren) { child in
              Text(child.name).tag(child.id as UUID?)
            }
          }
          .accessibilityLabel(Text("export.select.child"))
        }
      }
    }
  }

  @ViewBuilder private var exportButtonSection: some View {
    Section {
      switch exportState {
      case .idle:
        Button("export.generate.button", action: performExport)
          .buttonStyle(.glass)
          .disabled(!canExport)
          .frame(maxWidth: .infinity)
          .accessibilityLabel(Text("export.generate.button"))

      case .exporting:
        HStack {
          ProgressView()
          Text("export.generating")
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel(Text("export.generating"))

      case .success:
        if let url = exportedFileURL {
          ShareLink(item: url) {
            Label("export.share.file", systemImage: "square.and.arrow.up")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.glass)
          .accessibilityLabel(Text("export.share.file"))

          Button("export.regenerate", action: resetExport)
            .foregroundStyle(.secondary)
            .accessibilityLabel(Text("export.regenerate"))
        }

      case let .failure(error):
        VStack(spacing: 8) {
          Label("export.failed", systemImage: "exclamationmark.triangle")
            .foregroundStyle(.red)
            .accessibilityLabel(Text("export.failed"))
          Text(error)
            .font(.caption)
            .foregroundStyle(.secondary)
          Button("export.retry", action: performExport)
            .buttonStyle(.glass)
            .accessibilityLabel(Text("export.retry"))
        }
      }
    }
  }

  // MARK: - Logic

  private var canExport: Bool {
    guard !allChildren.isEmpty else { return false }
    if exportScope == .single, selectedChildId == nil {
      return false
    }
    return true
  }

  private func performExport() {
    exportState = .exporting

    Task {
      do {
        let childrenToExport = childrenForExport()
        let records = try fetchRecords(for: childrenToExport)

        let url: URL = switch exportFormat {
        case .csv:
          try exportService.exportCSV(children: childrenToExport, records: records)
        case .json:
          try exportService.exportJSON(children: childrenToExport, records: records)
        }

        exportedFileURL = url
        exportState = .success

        // Schedule cleanup of old files
        exportService.cleanupTemporaryFiles(olderThan: 3600)
      } catch {
        exportState = .failure(error.localizedDescription)
      }
    }
  }

  private func resetExport() {
    exportState = .idle
    exportedFileURL = nil
  }

  private func childrenForExport() -> [ChildEntity] {
    switch exportScope {
    case .all:
      return allChildren
    case .single:
      guard let id = selectedChildId else { return [] }
      return allChildren.filter { $0.id == id }
    }
  }

  private func fetchRecords(for children: [ChildEntity]) throws -> [MeasurementEntity] {
    let childIds = children.map(\.id)
    let predicate = #Predicate<MeasurementEntity> { record in
      childIds.contains(record.childId)
    }
    let descriptor = FetchDescriptor<MeasurementEntity>(
      predicate: predicate,
      sortBy: [SortDescriptor(\.recordedAt, order: .reverse)]
    )
    return try modelContext.fetch(descriptor)
  }
}

// MARK: - Supporting Types

enum ExportFormat: String, CaseIterable, Identifiable {
  case csv
  case json

  var id: String { rawValue }

  var displayName: String {
    switch self {
    case .csv: "CSV"
    case .json: "JSON"
    }
  }

  var description: String {
    switch self {
    case .csv:
      String(localized: "export.csv.description")
    case .json:
      String(localized: "export.json.description")
    }
  }

  var descriptionKey: LocalizedStringKey {
    switch self {
    case .csv:
      "export.csv.description"
    case .json:
      "export.json.description"
    }
  }
}

enum ExportScope {
  case all
  case single
}

enum ExportState: Equatable {
  case idle
  case exporting
  case success
  case failure(String)
}

#Preview("ExportView", traits: .modifier(SampleData())) {
  ExportView()
}
