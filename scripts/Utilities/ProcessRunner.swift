import Foundation

public struct ProcessResult {
  public let code: Int32
  public let stdout: String
  public let stderr: String
}

@discardableResult
public func run(_ launchPath: String, _ arguments: [String], quiet: Bool = false) -> ProcessResult {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: launchPath)
  process.arguments = arguments

  let outPipe = Pipe()
  let errPipe = Pipe()
  process.standardOutput = outPipe
  process.standardError = errPipe

  do {
    try process.run()
  } catch {
    if !quiet { fputs("Failed to start process: \(launchPath) \n", stderr) }
    return ProcessResult(code: 127, stdout: "", stderr: error.localizedDescription)
  }
  process.waitUntilExit()
  let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
  let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
  let outStr = String(data: outData, encoding: .utf8) ?? ""
  let errStr = String(data: errData, encoding: .utf8) ?? ""
  if !quiet {
    if !outStr.isEmpty { print(outStr) }
    if !errStr.isEmpty { fputs(errStr, stderr) }
  }
  return ProcessResult(code: process.terminationStatus, stdout: outStr, stderr: errStr)
}
