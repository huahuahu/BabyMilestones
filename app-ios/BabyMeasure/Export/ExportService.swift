import Foundation
import HStorage

/// Protocol defining export capabilities for child and measurement data.
protocol Exporting {
  /// Exports children and their measurements to CSV format.
  /// - Parameters:
  ///   - children: Array of children to export.
  ///   - records: Array of measurements to export.
  /// - Returns: URL to the temporary CSV file.
  func exportCSV(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL

  /// Exports children and their measurements to JSON format.
  /// - Parameters:
  ///   - children: Array of children to export.
  ///   - records: Array of measurements to export.
  /// - Returns: URL to the temporary JSON file.
  func exportJSON(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL

  /// Cleans up temporary export files older than the specified age.
  /// - Parameter olderThan: Time interval threshold for cleanup.
  func cleanupTemporaryFiles(olderThan: TimeInterval)
}

/// Service responsible for exporting child and measurement data to various formats.
@MainActor
final class ExportService: Exporting {
  /// Errors that can occur during export operations.
  enum ExportError: LocalizedError {
    case fileCreationFailed
    case encodingFailed

    var errorDescription: String? {
      switch self {
      case .fileCreationFailed:
        "无法创建导出文件"
      case .encodingFailed:
        "数据编码失败"
      }
    }
  }

  /// Directory for storing temporary export files.
  private var exportDirectory: URL {
    FileManager.default.temporaryDirectory.appending(path: "BabyMeasureExports")
  }

  /// ISO8601 formatter for dates.
  private let dateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  init() {
    // Ensure export directory exists
    try? FileManager.default.createDirectory(at: exportDirectory, withIntermediateDirectories: true)
  }

  // MARK: - CSV Export

  func exportCSV(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL {
    var csvContent = "child_id,name,gender,birthday,record_id,type,value,recorded_at\n"

    // Build a lookup for children
    let childLookup = Dictionary(uniqueKeysWithValues: children.map { ($0.id, $0) })

    for record in records {
      guard let child = childLookup[record.childId] else { continue }

      let row = [
        escapeCSV(child.id.uuidString),
        escapeCSV(child.name),
        escapeCSV(child.genderRaw ?? ""),
        escapeCSV(dateFormatter.string(from: child.birthday)),
        escapeCSV(record.id.uuidString),
        escapeCSV(record.typeRaw),
        String(record.value),
        escapeCSV(dateFormatter.string(from: record.recordedAt)),
      ].joined(separator: ",")

      csvContent += row + "\n"
    }

    // Also include children without records
    let recordedChildIds = Set(records.map(\.childId))
    for child in children where !recordedChildIds.contains(child.id) {
      let row = [
        escapeCSV(child.id.uuidString),
        escapeCSV(child.name),
        escapeCSV(child.genderRaw ?? ""),
        escapeCSV(dateFormatter.string(from: child.birthday)),
        "", // record_id
        "", // type
        "", // value
        "", // recorded_at
      ].joined(separator: ",")

      csvContent += row + "\n"
    }

    let fileName = "BabyMeasure_\(fileTimestamp()).csv"
    let fileURL = exportDirectory.appending(path: fileName)

    guard let data = csvContent.data(using: .utf8) else {
      throw ExportError.encodingFailed
    }

    try data.write(to: fileURL, options: .atomic)
    return fileURL
  }

  /// Escapes a string for CSV format, handling commas, quotes, and newlines.
  private func escapeCSV(_ value: String) -> String {
    let needsQuoting = value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r")
    if needsQuoting {
      let escaped = value.replacing("\"", with: "\"\"")
      return "\"\(escaped)\""
    }
    return value
  }

  // MARK: - JSON Export

  func exportJSON(children: [ChildEntity], records: [MeasurementEntity]) throws -> URL {
    let exportData = ExportData(
      version: "BabyMilestones-0.7",
      exportedAt: dateFormatter.string(from: Date()),
      children: children.map { ExportChild(from: $0) },
      records: records.map { ExportRecord(from: $0) }
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

    let data = try encoder.encode(exportData)

    let fileName = "BabyMeasure_\(fileTimestamp()).json"
    let fileURL = exportDirectory.appending(path: fileName)

    try data.write(to: fileURL, options: .atomic)
    return fileURL
  }

  // MARK: - Cleanup

  func cleanupTemporaryFiles(olderThan interval: TimeInterval = 3600) {
    let fileManager = FileManager.default
    guard let files = try? fileManager.contentsOfDirectory(at: exportDirectory, includingPropertiesForKeys: [.creationDateKey]) else {
      return
    }

    let threshold = Date().addingTimeInterval(-interval)

    for file in files {
      guard let attributes = try? file.resourceValues(forKeys: [.creationDateKey]),
            let creationDate = attributes.creationDate,
            creationDate < threshold
      else {
        continue
      }
      try? fileManager.removeItem(at: file)
    }
  }

  // MARK: - Helpers

  private func fileTimestamp() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd_HHmmss"
    return formatter.string(from: Date())
  }
}

// MARK: - Export Data Models

/// Root structure for JSON export.
struct ExportData: Codable {
  let version: String
  let exportedAt: String
  let children: [ExportChild]
  let records: [ExportRecord]
}

/// Child data for export.
struct ExportChild: Codable {
  let id: String
  let name: String
  let gender: String?
  let birthday: String

  init(from entity: ChildEntity) {
    id = entity.id.uuidString
    name = entity.name
    gender = entity.genderRaw
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]
    birthday = formatter.string(from: entity.birthday)
  }
}

/// Measurement record for export.
struct ExportRecord: Codable {
  let id: String
  let childId: String
  let type: String
  let value: Double
  let recordedAt: String

  init(from entity: MeasurementEntity) {
    id = entity.id.uuidString
    childId = entity.childId.uuidString
    type = entity.typeRaw
    value = entity.value
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    recordedAt = formatter.string(from: entity.recordedAt)
  }
}
