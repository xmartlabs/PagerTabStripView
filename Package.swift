// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "PagerTabStrip",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "PagerTabStrip", targets: ["PagerTabStrip"])
    ],
    targets: [
        .target(
            name: "PagerTabStrip",
            path: "Sources"
        ),
        .testTarget(
            name: "PagerTabStripTests",
            dependencies: ["PagerTabStrip"],
            path: "Tests"
        )
    ]
)
