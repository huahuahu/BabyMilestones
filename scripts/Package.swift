// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "BabyMilestones",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .executable(name: "hScript", targets: ["hScript"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
  ],
  targets: [
    // Development tools target - not used for the actual iOS app
    .executableTarget(
      name: "hScript",
      dependencies: [
        // .product(name: "swiftlint", package: "SwiftLint"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      path: "."
    ),
    .binaryTarget(
      name: "swiftformat",
      url: "https://github.com/nicklockwood/SwiftFormat/releases/download/0.58.1/swiftformat.artifactbundle.zip",
      checksum: "b6b8f837c527d2cabe38a6dbd14447d95d221a3c03e269542a276493ca51d4b1"
    ),
    .binaryTarget(
      name: "swiftlintBinary",
      url: "https://github.com/realm/SwiftLint/releases/download/0.61.0/SwiftLintBinary.artifactbundle.zip",
      checksum: "b765105fa5c5083fbcd35260f037b9f0d70e33992d0a41ba26f5f78a17dc65e7"
    ),
  ]
)
