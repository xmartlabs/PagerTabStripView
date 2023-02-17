// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "PagerTabStripView",
    platforms: [.iOS(.v15), .macOS(.v12)],
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
            path: "PagerTabStripViewTests",
            linkerSettings: [
                .linkedFramework("CoreGraphics", .when(platforms: [.macOS, .iOS])),
                .linkedFramework("Foundation", .when(platforms: [.macOS, .iOS]))
            ]
        )
    ]
)
