// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "swift-reachability",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftReachability",
            targets: ["SwiftReachability"]
        )
    ],
    targets: [
        .target(
            name: "SwiftReachability",
            path: "Sources",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SwiftReachabilityTests",
            dependencies: ["SwiftReachability"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
