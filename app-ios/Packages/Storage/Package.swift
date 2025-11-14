// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "Storage",
  platforms: [
    .iOS(.v26)
  ],
  products: [
    .library(
      name: "Storage",
      targets: ["Storage"]
    )
  ],
  targets: [
    .target(
      name: "Storage",
      swiftSettings: [
        .enableUpcomingFeature("ExistentialAny")
      ]
    )
  ]
)
