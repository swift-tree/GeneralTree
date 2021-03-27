// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "GeneralTree",
  products: [
    .library(
      name: "GeneralTree",
      targets: ["GeneralTree"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swift-tree/Tree.git", .exact("1.0.2")),
  ],
  targets: [
    .target(
      name: "GeneralTree",
      dependencies: ["Tree"]
    ),
    .testTarget(
      name: "GeneralTreeTests",
      dependencies: ["GeneralTree", "Tree"]
    ),
  ]
)
