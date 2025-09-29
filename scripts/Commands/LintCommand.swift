import ArgumentParser
import Foundation

struct LintResult {
  let swiftLintExit: Int32
  let swiftFormatExit: Int32
  var success: Bool { swiftLintExit == 0 && swiftFormatExit == 0 }
}

enum LintMode { case check, fix }

func runLint(mode: LintMode) -> LintResult {
  let fileManager = FileManager.default
  let cwd = fileManager.currentDirectoryPath
  let repoRoot: String = cwd.hasSuffix("/scripts") ? String(cwd.dropLast("/scripts".count)) : cwd

  // Determine config file paths (optional if missing).
  let swiftLintConfig = repoRoot + "/.swiftlint.yml"
  let hasSwiftLintConfig = fileManager.fileExists(atPath: swiftLintConfig)
  let swiftFormatConfig = repoRoot + "/.swiftformat"
  let hasSwiftFormatConfig = fileManager.fileExists(atPath: swiftFormatConfig)

  // Run SwiftLint via local binary or swift run fallback with explicit config if present.
  let swiftLintExit: Int32 = runSwiftLintPipeline(mode: mode, configPath: hasSwiftLintConfig ? swiftLintConfig : nil)

  // Run SwiftFormat similarly with config.
  let swiftFormatExit: Int32 = runSwiftFormatPipeline(
    mode: mode,
    repoRoot: repoRoot,
    configPath: hasSwiftFormatConfig ? swiftFormatConfig : nil
  )

  return LintResult(swiftLintExit: swiftLintExit, swiftFormatExit: swiftFormatExit)
}

// MARK: - SwiftLint Binary Resolution

/// Attempts to locate the SwiftLint executable produced by the SwiftPM dependency.
/// Search order:
/// 1. Environment override: SWIFTLINT_PATH
/// 2. scripts/.build/debug/swiftlint (if running inside repo root) or currentDir/.build/debug/swiftlint (if already inside scripts)
/// 3. Release variant of the above
/// If not found, triggers a build (`swift build --package-path scripts`) once and re-checks.
/// Returns nil if still not locatable so caller can fall back to system `swiftlint`.
private func findLocalSwiftLint() -> String? {
  if let override = ProcessInfo.processInfo.environment["SWIFTLINT_PATH"], !override.isEmpty,
     FileManager.default.isExecutableFile(atPath: override)
  {
    return override
  }

  let fileManager = FileManager.default
  let cwd = fileManager.currentDirectoryPath
  // Determine scripts directory path
  let scriptsDir: String = cwd.hasSuffix("/scripts") ? cwd : cwd + "/scripts"

  func candidatePaths() -> [String] {
    [
      scriptsDir + "/.build/artifacts/scripts/SwiftLintBinary/SwiftLintBinary.artifactbundle/swiftlint-0.61.0-macos/bin/swiftlint",
      // Older SwiftPM structures sometimes omit the trailing executable name casing differences; keep minimal.
    ]
  }

  for path in candidatePaths() where fileManager.isExecutableFile(atPath: path) {
    return path
  }

  // Attempt a build to materialize dependency executables if they don't exist yet.
  _ = run("/usr/bin/swift", ["build", "--package-path", scriptsDir], quiet: true)

  for path in candidatePaths() where fileManager.isExecutableFile(atPath: path) {
    return path
  }

  return nil
}

// MARK: - SwiftFormat Binary Resolution

private func findLocalSwiftFormat() -> String? {
  if let override = ProcessInfo.processInfo.environment["SWIFTFORMAT_PATH"], !override.isEmpty,
     FileManager.default.isExecutableFile(atPath: override)
  {
    return override
  }
  let fileManager = FileManager.default
  let cwd = fileManager.currentDirectoryPath
  let scriptsDir: String = cwd.hasSuffix("/scripts") ? cwd : cwd + "/scripts"
  let candidates = [
    scriptsDir + "/.build/artifacts/scripts/swiftformat/swiftformat.artifactbundle/swiftformat-0.58.1-macos/bin/swiftformat",
  ]
  for path in candidates where fileManager.isExecutableFile(atPath: path) {
    return path
  }
  _ = run("/usr/bin/swift", ["build", "--package-path", scriptsDir], quiet: true)
  for path in candidates where fileManager.isExecutableFile(atPath: path) {
    return path
  }
  return nil
}

// MARK: - Pipelines

@discardableResult
private func runSwiftLintPipeline(mode: LintMode, configPath: String?) -> Int32 {
  let local = findLocalSwiftLint()
  let scriptsDir: String = {
    let cwd = FileManager.default.currentDirectoryPath
    return cwd.hasSuffix("/scripts") ? cwd : cwd + "/scripts"
  }()

  func invoke(_ args: [String]) -> Int32 {
    if let local, FileManager.default.isExecutableFile(atPath: local) {
      return run(local, args).code
    }
    // Fallback to swift run swiftlint
    return run("/usr/bin/swift", ["run", "--package-path", scriptsDir, "swiftlint"] + args).code
  }

  let configArgs: [String] = configPath.map { ["--config", $0] } ?? []
  switch mode {
  case .fix:
    var exitCode = invoke(["--fix", "--format"] + configArgs) // '--format' retained
    let verify = invoke(["lint"] + configArgs) // verify remaining issues
    if verify != 0 { exitCode = verify }
    return exitCode
  case .check:
    return invoke(configArgs)
  }
}

@discardableResult
private func runSwiftFormatPipeline(mode: LintMode, repoRoot: String, configPath: String?) -> Int32 {
  let local = findLocalSwiftFormat()
  let scriptsDir: String = {
    let cwd = FileManager.default.currentDirectoryPath
    return cwd.hasSuffix("/scripts") ? cwd : cwd + "/scripts"
  }()

  func invoke(_ args: [String]) -> Int32 {
    if let local, FileManager.default.isExecutableFile(atPath: local) {
      return run(local, args).code
    }
    // Fallback to swift run SwiftFormat (its executable target is named 'swiftformat')
    return run("/usr/bin/swift", ["run", "--package-path", scriptsDir, "swiftformat"] + args).code
  }

  let configArgs: [String] = configPath.map { ["--config", $0] } ?? []
  switch mode {
  case .fix:
    var exitCode = invoke([repoRoot] + configArgs)
    let verify = invoke([repoRoot, "--lint"] + configArgs)
    if verify != 0 { exitCode = verify }
    return exitCode
  case .check:
    return invoke([repoRoot, "--lint"] + configArgs)
  }
}

extension DevTools {
  struct Lint: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Run SwiftLint & SwiftFormat")

    @Flag(name: .shortAndLong, help: "Attempt to auto-fix issues (default is check-only).")
    var fix: Bool = false

    func run() throws {
      let mode: LintMode = fix ? .fix : .check
      let result = runLint(mode: mode)
      if result.success {
        print("✅ Lint passed")
      } else {
        throw ExitCode(1)
      }
    }
  }
}
