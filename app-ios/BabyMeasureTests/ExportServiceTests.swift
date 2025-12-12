import Foundation
import HStorage
import Testing

@testable import BabyMeasure

@MainActor
@Suite("ExportService Tests")
struct ExportServiceTests {
  let exportService = ExportService()

  // MARK: - Test Data

  func makeSampleChild(
    id: UUID = UUID(),
    name: String = "测试儿童",
    genderRaw: String? = "male",
    birthday: Date = Date()
  ) -> ChildEntity {
    ChildEntity(
      id: id,
      name: name,
      genderRaw: genderRaw,
      birthday: birthday
    )
  }

  func makeSampleMeasurement(
    id: UUID = UUID(),
    childId: UUID,
    typeRaw: String = "height",
    value: Double = 75.5,
    recordedAt: Date = Date()
  ) -> MeasurementEntity {
    MeasurementEntity(
      id: id,
      childId: childId,
      typeRaw: typeRaw,
      value: value,
      recordedAt: recordedAt
    )
  }

  // MARK: - CSV Tests

  @Test("CSV export creates file with correct header")
  func cSVBasicHeader() throws {
    let child = makeSampleChild()
    let record = makeSampleMeasurement(childId: child.id)

    let url = try exportService.exportCSV(children: [child], records: [record])

    #expect(FileManager.default.fileExists(atPath: url.path()))
    let content = try String(contentsOf: url, encoding: .utf8)
    #expect(content.hasPrefix("child_id,name,gender,birthday,record_id,type,value,recorded_at"))

    // Cleanup
    try? FileManager.default.removeItem(at: url)
  }

  @Test("CSV export contains correct number of data rows")
  func cSVRowCount() throws {
    let child = makeSampleChild()
    let record1 = makeSampleMeasurement(childId: child.id, typeRaw: "height", value: 75.0)
    let record2 = makeSampleMeasurement(childId: child.id, typeRaw: "weight", value: 10.5)

    let url = try exportService.exportCSV(children: [child], records: [record1, record2])
    let content = try String(contentsOf: url, encoding: .utf8)
    let lines = content.split(separator: "\n", omittingEmptySubsequences: false)

    // Header + 2 data rows
    #expect(lines.count >= 3)

    try? FileManager.default.removeItem(at: url)
  }

  @Test("CSV escapes special characters correctly")
  func cSVEscaping() throws {
    let child = makeSampleChild(name: "名字,带逗号")
    let record = makeSampleMeasurement(childId: child.id)

    let url = try exportService.exportCSV(children: [child], records: [record])
    let content = try String(contentsOf: url, encoding: .utf8)

    // Name with comma should be quoted
    #expect(content.contains("\"名字,带逗号\""))

    try? FileManager.default.removeItem(at: url)
  }

  @Test("CSV escapes quotes correctly")
  func cSVQuoteEscaping() throws {
    let child = makeSampleChild(name: "名字\"带引号")
    let record = makeSampleMeasurement(childId: child.id)

    let url = try exportService.exportCSV(children: [child], records: [record])
    let content = try String(contentsOf: url, encoding: .utf8)

    // Quotes should be doubled
    #expect(content.contains("\"名字\"\"带引号\""))

    try? FileManager.default.removeItem(at: url)
  }

  @Test("CSV includes children without records")
  func cSVChildrenWithoutRecords() throws {
    let child1 = makeSampleChild(name: "有记录")
    let child2 = makeSampleChild(name: "无记录")
    let record = makeSampleMeasurement(childId: child1.id)

    let url = try exportService.exportCSV(children: [child1, child2], records: [record])
    let content = try String(contentsOf: url, encoding: .utf8)

    #expect(content.contains("有记录"))
    #expect(content.contains("无记录"))

    try? FileManager.default.removeItem(at: url)
  }

  // MARK: - JSON Tests

  @Test("JSON export creates valid file")
  func jSONBasic() throws {
    let child = makeSampleChild()
    let record = makeSampleMeasurement(childId: child.id)

    let url = try exportService.exportJSON(children: [child], records: [record])

    #expect(FileManager.default.fileExists(atPath: url.path()))
    #expect(url.pathExtension == "json")

    try? FileManager.default.removeItem(at: url)
  }

  @Test("JSON export contains correct version")
  func jSONVersion() throws {
    let child = makeSampleChild()

    let url = try exportService.exportJSON(children: [child], records: [])
    let data = try Data(contentsOf: url)
    let json = try JSONDecoder().decode(ExportData.self, from: data)

    #expect(json.version == "BabyMilestones-0.7")

    try? FileManager.default.removeItem(at: url)
  }

  @Test("JSON export contains all children")
  func jSONChildren() throws {
    let child1 = makeSampleChild(name: "儿童1")
    let child2 = makeSampleChild(name: "儿童2")

    let url = try exportService.exportJSON(children: [child1, child2], records: [])
    let data = try Data(contentsOf: url)
    let json = try JSONDecoder().decode(ExportData.self, from: data)

    #expect(json.children.count == 2)
    #expect(json.children.map(\.name).contains("儿童1"))
    #expect(json.children.map(\.name).contains("儿童2"))

    try? FileManager.default.removeItem(at: url)
  }

  @Test("JSON export contains all records")
  func jSONRecords() throws {
    let child = makeSampleChild()
    let record1 = makeSampleMeasurement(childId: child.id, typeRaw: "height", value: 75.0)
    let record2 = makeSampleMeasurement(childId: child.id, typeRaw: "weight", value: 10.5)

    let url = try exportService.exportJSON(children: [child], records: [record1, record2])
    let data = try Data(contentsOf: url)
    let json = try JSONDecoder().decode(ExportData.self, from: data)

    #expect(json.records.count == 2)

    try? FileManager.default.removeItem(at: url)
  }

  @Test("JSON record contains correct fields")
  func jSONRecordFields() throws {
    let child = makeSampleChild()
    let record = makeSampleMeasurement(childId: child.id, typeRaw: "height", value: 80.5)

    let url = try exportService.exportJSON(children: [child], records: [record])
    let data = try Data(contentsOf: url)
    let json = try JSONDecoder().decode(ExportData.self, from: data)

    let exportedRecord = json.records.first!
    #expect(exportedRecord.type == "height")
    #expect(exportedRecord.value == 80.5)
    #expect(exportedRecord.childId == child.id.uuidString)

    try? FileManager.default.removeItem(at: url)
  }

  // MARK: - Selective Export Tests

  @Test("Selective export only includes specified child")
  func selectiveExport() throws {
    let child1 = makeSampleChild(name: "儿童1")
    let child2 = makeSampleChild(name: "儿童2")
    let record1 = makeSampleMeasurement(childId: child1.id)
    let record2 = makeSampleMeasurement(childId: child2.id)

    // Export only child1
    let url = try exportService.exportJSON(children: [child1], records: [record1])
    let data = try Data(contentsOf: url)
    let json = try JSONDecoder().decode(ExportData.self, from: data)

    #expect(json.children.count == 1)
    #expect(json.children.first?.name == "儿童1")
    #expect(json.records.count == 1)

    try? FileManager.default.removeItem(at: url)
  }

  // MARK: - File Existence Tests

  @Test("Export file exists and is non-empty")
  func shareFileExists() throws {
    let child = makeSampleChild()
    let record = makeSampleMeasurement(childId: child.id)

    let csvURL = try exportService.exportCSV(children: [child], records: [record])
    let jsonURL = try exportService.exportJSON(children: [child], records: [record])

    #expect(FileManager.default.fileExists(atPath: csvURL.path()))
    #expect(FileManager.default.fileExists(atPath: jsonURL.path()))

    let csvData = try Data(contentsOf: csvURL)
    let jsonData = try Data(contentsOf: jsonURL)

    #expect(!csvData.isEmpty)
    #expect(!jsonData.isEmpty)

    try? FileManager.default.removeItem(at: csvURL)
    try? FileManager.default.removeItem(at: jsonURL)
  }

  // MARK: - Cleanup Tests

  @Test("Cleanup removes old files")
  func cleanup() throws {
    let child = makeSampleChild()

    // Create a file
    let url = try exportService.exportCSV(children: [child], records: [])
    #expect(FileManager.default.fileExists(atPath: url.path()))

    // Cleanup with 0 threshold should remove the file immediately
    exportService.cleanupTemporaryFiles(olderThan: 0)

    // File should be removed
    #expect(!FileManager.default.fileExists(atPath: url.path()))
  }
}
