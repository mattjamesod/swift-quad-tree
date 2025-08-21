// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "QuadTree",
    platforms: [.macOS(.v15), .iOS(.v17)],
    products: [
        .library(
            name: "QuadTree",
            targets: ["QuadTree"]
        ),
    ],
    targets: [
        .target(
            name: "QuadTree"),
        .testTarget(
            name: "QuadTreeTests",
            dependencies: ["QuadTree"]
        ),
    ]
)
