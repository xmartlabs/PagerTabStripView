// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "PagerTabStripView",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "PagerTabStripView", targets: ["PagerTabStripView"])
    ],
    targets: [
        .target(
            name: "PagerTabStripView",
            path: "Sources"
        ),
        .testTarget(
            name: "PagerTabStripViewTests",
            dependencies: ["PagerTabStripView"],
            path: "Tests"
        )
    ]
)
