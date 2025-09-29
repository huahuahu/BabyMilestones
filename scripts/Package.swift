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
    .package(url: "https://github.com/realm/SwiftLint.git", from: "0.57.0"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.0"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
  ],
  targets: [
    // Development tools target - not used for the actual iOS app
    .executableTarget(
      name: "hScript",
      dependencies: [
        .product(name: "swiftlint", package: "SwiftLint"),
        .product(name: "SwiftFormat", package: "SwiftFormat"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      path: "."
    ),
  ]
)
