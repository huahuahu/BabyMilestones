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
      .navigationTitle("导出数据")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("取消") { dismiss() }
        }
      }
    }
  }

  // MARK: - Sections

  private var formatSection: some View {
    Section {
      Picker("导出格式", selection: $exportFormat) {
        ForEach(ExportFormat.allCases) { format in
          Text(format.displayName).tag(format)
        }
      }
      .pickerStyle(.segmented)
    } header: {
      Text("格式")
    } footer: {
      Text(exportFormat.description)
    }
  }

  private var scopeSection: some View {
    Section("导出范围") {
      Picker("范围", selection: $exportScope) {
        Text("全部儿童").tag(ExportScope.all)
        Text("单个儿童").tag(ExportScope.single)
      }
      .pickerStyle(.segmented)

      if exportScope == .single {
        if allChildren.isEmpty {
          Text("暂无儿童数据")
            .foregroundStyle(.secondary)
        } else {
          Picker("选择儿童", selection: $selectedChildId) {
            Text("请选择").tag(nil as UUID?)
            ForEach(allChildren) { child in
              Text(child.name).tag(child.id as UUID?)
            }
          }
        }
      }
    }
  }

  @ViewBuilder private var exportButtonSection: some View {
    Section {
      switch exportState {
      case .idle:
        Button("生成导出文件", action: performExport)
          .disabled(!canExport)
          .frame(maxWidth: .infinity)

      case .exporting:
        HStack {
          ProgressView()
          Text("正在生成...")
        }
        .frame(maxWidth: .infinity)

      case .success:
        if let url = exportedFileURL {
          ShareLink(item: url) {
            Label("分享文件", systemImage: "square.and.arrow.up")
              .frame(maxWidth: .infinity)
          }

          Button("重新生成", action: resetExport)
            .foregroundStyle(.secondary)
        }

      case let .failure(error):
        VStack(spacing: 8) {
          Label("导出失败", systemImage: "exclamationmark.triangle")
            .foregroundStyle(.red)
          Text(error)
            .font(.caption)
            .foregroundStyle(.secondary)
          Button("重试", action: performExport)
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
      "逗号分隔值格式，适合 Excel 等表格软件打开"
    case .json:
      "结构化数据格式，适合程序处理和备份"
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
