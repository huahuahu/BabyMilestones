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
      .navigationTitle(String(localized: "export.title"))
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(String(localized: "common.cancel")) { dismiss() }
            .accessibilityLabel(String(localized: "common.cancel"))
        }
      }
    }
  }

  // MARK: - Sections

  private var formatSection: some View {
    Section {
      Picker(String(localized: "export.format"), selection: $exportFormat) {
        ForEach(ExportFormat.allCases) { format in
          Text(format.displayName).tag(format)
        }
      }
      .pickerStyle(.segmented)
      .accessibilityLabel(String(localized: "export.format"))
    } header: {
      Text(String(localized: "export.format.section"))
    } footer: {
      Text(exportFormat.description)
    }
  }

  private var scopeSection: some View {
    Section(String(localized: "export.scope")) {
      Picker(String(localized: "export.scope"), selection: $exportScope) {
        Text(String(localized: "export.scope.all")).tag(ExportScope.all)
        Text(String(localized: "export.scope.single")).tag(ExportScope.single)
      }
      .pickerStyle(.segmented)
      .accessibilityLabel(String(localized: "export.scope"))

      if exportScope == .single {
        if allChildren.isEmpty {
          Text(String(localized: "no.children.data"))
            .foregroundStyle(.secondary)
        } else {
          Picker(String(localized: "export.select.child"), selection: $selectedChildId) {
            Text(String(localized: "export.select.placeholder")).tag(nil as UUID?)
            ForEach(allChildren) { child in
              Text(child.name).tag(child.id as UUID?)
            }
          }
          .accessibilityLabel(String(localized: "export.select.child"))
        }
      }
    }
  }

  @ViewBuilder private var exportButtonSection: some View {
    Section {
      switch exportState {
      case .idle:
        Button(String(localized: "export.generate.button"), action: performExport)
          .buttonStyle(.glass)
          .disabled(!canExport)
          .frame(maxWidth: .infinity)
          .accessibilityLabel(String(localized: "export.generate.button"))

      case .exporting:
        HStack {
          ProgressView()
          Text(String(localized: "export.generating"))
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel(String(localized: "export.generating"))

      case .success:
        if let url = exportedFileURL {
          ShareLink(item: url) {
            Label(String(localized: "export.share.file"), systemImage: "square.and.arrow.up")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.glass)
          .accessibilityLabel(String(localized: "export.share.file"))

          Button(String(localized: "export.regenerate"), action: resetExport)
            .foregroundStyle(.secondary)
            .accessibilityLabel(String(localized: "export.regenerate"))
        }

      case let .failure(error):
        VStack(spacing: 8) {
          Label(String(localized: "export.failed"), systemImage: "exclamationmark.triangle")
            .foregroundStyle(.red)
            .accessibilityLabel(String(localized: "export.failed"))
          Text(error)
            .font(.caption)
            .foregroundStyle(.secondary)
          Button(String(localized: "export.retry"), action: performExport)
            .buttonStyle(.glass)
            .accessibilityLabel(String(localized: "export.retry"))
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
