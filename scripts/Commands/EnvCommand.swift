import ArgumentParser
import Foundation

extension DevTools {
  struct Env: ParsableCommand {
    static var configuration = CommandConfiguration(
      abstract: "Print environment information for CI debugging"
    )

    @Flag(name: .shortAndLong, help: "Output in JSON format")
    var json: Bool = false

    func run() throws {
      let envInfo = collectEnvironmentInfo()

      if json {
        printJSON(envInfo)
      } else {
        printFormatted(envInfo)
      }
    }
  }
}

private struct EnvironmentInfo {
  let system: SystemInfo
  let xcode: XcodeInfo
  let simulators: [SimulatorInfo]
  let swift: SwiftInfo
  let git: GitInfo
  // swiftlint:disable:next identifier_name
  let ci: CIInfo
}

private struct SystemInfo {
  let osVersion: String
  let architecture: String
  let hostname: String
  let uptime: String
  let diskSpace: String
}

private struct XcodeInfo {
  let version: String?
  let buildVersion: String?
  let path: String?
  let commandLineTools: String?
  let availableSDKs: [String]
}

private struct SimulatorInfo {
  let name: String
  let identifier: String
  let state: String
  let runtime: String
  let deviceType: String
}

private struct SwiftInfo {
  let version: String
  let targetTriple: String
}

private struct GitInfo {
  let version: String
  let branch: String?
  let commit: String?
  let status: String?
}

private struct CIInfo {
  let isCI: Bool
  let provider: String?
  let jobId: String?
  let buildNumber: String?
  let environment: [String: String]
}

private func collectEnvironmentInfo() -> EnvironmentInfo {
  EnvironmentInfo(
    system: collectSystemInfo(),
    xcode: collectXcodeInfo(),
    simulators: collectSimulatorInfo(),
    swift: collectSwiftInfo(),
    git: collectGitInfo(),
    ci: collectCIInfo()
  )
}

private func collectSystemInfo() -> SystemInfo {
  let osVersion = run("/usr/bin/sw_vers", ["-productVersion"], quiet: true).stdout.trimmingCharacters(in: .whitespacesAndNewlines)
  let architecture = run("/usr/bin/uname", ["-m"], quiet: true).stdout.trimmingCharacters(in: .whitespacesAndNewlines)
  let hostname = run("/bin/hostname", [], quiet: true).stdout.trimmingCharacters(in: .whitespacesAndNewlines)
  let uptime = run("/usr/bin/uptime", [], quiet: true).stdout.trimmingCharacters(in: .whitespacesAndNewlines)
  let diskSpace = run("/bin/df", ["-h", "/"], quiet: true).stdout

  return SystemInfo(
    osVersion: osVersion,
    architecture: architecture,
    hostname: hostname,
    uptime: uptime,
    diskSpace: diskSpace
  )
}

private func collectXcodeInfo() -> XcodeInfo {
  let xcodeSelectPath = run("/usr/bin/xcode-select", ["-p"], quiet: true)
  let xcodePath = xcodeSelectPath.code == 0 ? xcodeSelectPath.stdout.trimmingCharacters(in: .whitespacesAndNewlines) : nil

  let xcodebuildVersion = run("/usr/bin/xcodebuild", ["-version"], quiet: true)
  var version: String?
  var buildVersion: String?

  if xcodebuildVersion.code == 0 {
    let lines = xcodebuildVersion.stdout.components(separatedBy: .newlines)
    for line in lines {
      if line.hasPrefix("Xcode ") {
        version = String(line.dropFirst("Xcode ".count))
      } else if line.hasPrefix("Build version ") {
        buildVersion = String(line.dropFirst("Build version ".count))
      }
    }
  }

  let commandLineTools = run("/usr/bin/pkgutil", ["--pkg-info=com.apple.pkg.CLTools_Executables"], quiet: true)
  let cltVersion = commandLineTools.code == 0 ?
    commandLineTools.stdout.components(separatedBy: .newlines)
    .first { $0.contains("version:") }?
    .components(separatedBy: "version: ").last : nil

  let sdks = run("/usr/bin/xcodebuild", ["-showsdks"], quiet: true)
  let availableSDKs: [String] = sdks.code == 0 ?
    sdks.stdout.components(separatedBy: .newlines)
    .compactMap { line in
      if line.contains("-sdk ") {
        return line.components(separatedBy: "-sdk ").last
      }
      return nil
    } : []

  return XcodeInfo(
    version: version,
    buildVersion: buildVersion,
    path: xcodePath,
    commandLineTools: cltVersion,
    availableSDKs: availableSDKs
  )
}

private func collectSimulatorInfo() -> [SimulatorInfo] {
  let result = run("/usr/bin/xcrun", ["simctl", "list", "devices", "--json"], quiet: true)
  guard result.code == 0,
        let data = result.stdout.data(using: .utf8),
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let devices = json["devices"] as? [String: Any]
  else {
    return []
  }

  var simulators: [SimulatorInfo] = []

  for (runtime, deviceList) in devices {
    guard let devices = deviceList as? [[String: Any]] else { continue }

    for device in devices {
      guard let name = device["name"] as? String,
            let identifier = device["udid"] as? String,
            let state = device["state"] as? String,
            let deviceTypeIdentifier = device["deviceTypeIdentifier"] as? String
      else {
        continue
      }

      simulators.append(SimulatorInfo(
        name: name,
        identifier: identifier,
        state: state,
        runtime: runtime,
        deviceType: deviceTypeIdentifier
      ))
    }
  }

  return simulators
}

private func collectSwiftInfo() -> SwiftInfo {
  let versionResult = run("/usr/bin/swift", ["--version"], quiet: true)
  let version = versionResult.code == 0 ?
    versionResult.stdout.trimmingCharacters(in: .whitespacesAndNewlines) : "Unknown"

  let targetResult = run("/usr/bin/swift", ["-print-target-info"], quiet: true)
  var targetTriple = "Unknown"

  if targetResult.code == 0,
     let data = targetResult.stdout.data(using: .utf8),
     let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
     let target = json["target"] as? [String: Any],
     let triple = target["triple"] as? String
  {
    targetTriple = triple
  }

  return SwiftInfo(version: version, targetTriple: targetTriple)
}

private func collectGitInfo() -> GitInfo {
  let versionResult = run("/usr/bin/git", ["--version"], quiet: true)
  let version = versionResult.code == 0 ?
    versionResult.stdout.trimmingCharacters(in: .whitespacesAndNewlines) : "Not available"

  let branchResult = run("/usr/bin/git", ["rev-parse", "--abbrev-ref", "HEAD"], quiet: true)
  let branch = branchResult.code == 0 ?
    branchResult.stdout.trimmingCharacters(in: .whitespacesAndNewlines) : nil

  let commitResult = run("/usr/bin/git", ["rev-parse", "HEAD"], quiet: true)
  let commit = commitResult.code == 0 ?
    commitResult.stdout.trimmingCharacters(in: .whitespacesAndNewlines) : nil

  let statusResult = run("/usr/bin/git", ["status", "--porcelain"], quiet: true)
  let status = statusResult.code == 0 ?
    (statusResult.stdout.isEmpty ? "Clean" : "Modified") : nil

  return GitInfo(version: version, branch: branch, commit: commit, status: status)
}

private func collectCIInfo() -> CIInfo {
  let env = ProcessInfo.processInfo.environment

  // Common CI environment variables
  let ciVariables = [
    "CI", "CONTINUOUS_INTEGRATION", // Generic
    "GITHUB_ACTIONS", "GITHUB_RUN_ID", "GITHUB_WORKFLOW", // GitHub Actions
    "TRAVIS", "TRAVIS_BUILD_NUMBER", "TRAVIS_JOB_ID", // Travis CI
    "JENKINS_URL", "BUILD_NUMBER", "JOB_NAME", // Jenkins
    "CIRCLECI", "CIRCLE_BUILD_NUM", "CIRCLE_JOB", // CircleCI
    "BITBUCKET_BUILD_NUMBER", "BITBUCKET_REPO_SLUG", // Bitbucket Pipelines
    "XCODE_CLOUD", "CI_XCODE_PROJECT", "CI_WORKFLOW", // Xcode Cloud
  ]

  let isCI = env["CI"] != nil || env["CONTINUOUS_INTEGRATION"] != nil

  var provider: String?
  var jobId: String?
  var buildNumber: String?

  if env["GITHUB_ACTIONS"] != nil {
    provider = "GitHub Actions"
    jobId = env["GITHUB_RUN_ID"]
    buildNumber = env["GITHUB_RUN_NUMBER"]
  } else if env["TRAVIS"] != nil {
    provider = "Travis CI"
    jobId = env["TRAVIS_JOB_ID"]
    buildNumber = env["TRAVIS_BUILD_NUMBER"]
  } else if env["JENKINS_URL"] != nil {
    provider = "Jenkins"
    jobId = env["JOB_NAME"]
    buildNumber = env["BUILD_NUMBER"]
  } else if env["CIRCLECI"] != nil {
    provider = "CircleCI"
    jobId = env["CIRCLE_JOB"]
    buildNumber = env["CIRCLE_BUILD_NUM"]
  } else if env["XCODE_CLOUD"] != nil {
    provider = "Xcode Cloud"
    jobId = env["CI_WORKFLOW"]
    buildNumber = env["CI_BUILD_NUMBER"]
  } else if isCI {
    provider = "Unknown CI Provider"
  }

  let ciEnvironment: [String: String] = Dictionary(uniqueKeysWithValues:
    ciVariables.compactMap { key in
      guard let value = env[key] else { return nil }
      return (key, value)
    }
  )

  return CIInfo(
    isCI: isCI,
    provider: provider,
    jobId: jobId,
    buildNumber: buildNumber,
    environment: ciEnvironment
  )
}

private func printFormatted(_ info: EnvironmentInfo) {
  print("🔍 Environment Information")
  print("=" * 50)

  print("\n📱 System Information:")
  print("  macOS Version: \(info.system.osVersion)")
  print("  Architecture: \(info.system.architecture)")
  print("  Hostname: \(info.system.hostname)")
  print("  Uptime: \(info.system.uptime)")
  print("  Disk Space:")
  print(info.system.diskSpace.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .map { "    \($0)" }
    .joined(separator: "\n"))

  print("\n🔨 Xcode Information:")
  print("  Version: \(info.xcode.version ?? "Not found")")
  print("  Build Version: \(info.xcode.buildVersion ?? "Not found")")
  print("  Installation Path: \(info.xcode.path ?? "Not found")")
  print("  Command Line Tools: \(info.xcode.commandLineTools ?? "Not found")")
  print("  Available SDKs: \(info.xcode.availableSDKs.isEmpty ? "None" : info.xcode.availableSDKs.joined(separator: ", "))")

  print("\n📱 Simulators:")
  if info.simulators.isEmpty {
    print("  No simulators found")
  } else {
    let groupedByRuntime = Dictionary(grouping: info.simulators, by: { $0.runtime })
    for (runtime, sims) in groupedByRuntime.sorted(by: { $0.key < $1.key }) {
      print("  \(runtime):")
      for sim in sims.sorted(by: { $0.name < $1.name }) {
        let stateIcon = sim.state == "Booted" ? "🟢" : (sim.state == "Shutdown" ? "⚪" : "🔴")
        print("    \(stateIcon) \(sim.name) (\(sim.state))")
      }
    }
  }

  print("\n🚀 Swift Information:")
  print("  Version: \(info.swift.version)")
  print("  Target Triple: \(info.swift.targetTriple)")

  print("\n📝 Git Information:")
  print("  Version: \(info.git.version)")
  if let branch = info.git.branch {
    print("  Current Branch: \(branch)")
  }
  if let commit = info.git.commit {
    print("  Current Commit: \(String(commit.prefix(8)))")
  }
  if let status = info.git.status {
    let statusIcon = status == "Clean" ? "✅" : "⚠️"
    print("  Working Tree: \(statusIcon) \(status)")
  }

  print("\n🤖 CI Information:")
  print("  Running in CI: \(info.ci.isCI ? "✅ Yes" : "❌ No")")
  if let provider = info.ci.provider {
    print("  CI Provider: \(provider)")
  }
  if let jobId = info.ci.jobId {
    print("  Job ID: \(jobId)")
  }
  if let buildNumber = info.ci.buildNumber {
    print("  Build Number: \(buildNumber)")
  }

  if !info.ci.environment.isEmpty {
    print("  CI Environment Variables:")
    for (key, value) in info.ci.environment.sorted(by: { $0.key < $1.key }) {
      print("    \(key): \(value)")
    }
  }

  // Project-specific environment variables (prefixed with BM_) for feature flags or local overrides.
  let projectEnv = ProcessInfo.processInfo.environment.filter { $0.key.hasPrefix("BM_") }
  if !projectEnv.isEmpty {
    print("\n🎯 Project Environment Overrides (BM_*):")
    for (key, value) in projectEnv.sorted(by: { $0.key < $1.key }) {
      print("  \(key): \(value)")
    }
  } else {
    print("\n🎯 Project Environment Overrides (BM_*): None detected")
  }
}

private func printJSON(_ info: EnvironmentInfo) {
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

  do {
    let jsonData = try encoder.encode(info)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
      print(jsonString)
    }
  } catch {
    print("Error encoding to JSON: \(error)")
  }
}

// Make structs Codable for JSON output
extension EnvironmentInfo: Codable {}
extension SystemInfo: Codable {}
extension XcodeInfo: Codable {}
extension SimulatorInfo: Codable {}
extension SwiftInfo: Codable {}
extension GitInfo: Codable {}
extension CIInfo: Codable {}

// Helper for string repetition
private func * (lhs: String, rhs: Int) -> String {
  String(repeating: lhs, count: rhs)
}
