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
    .package(path: "../Tree"),
    // .package(url: "https://github.com/erkekin/Tree.git", .exact("0.1.7"))
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
