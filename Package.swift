// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "AstrbotLauncher",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .executable(name: "AstrbotLauncher", targets: ["AstrbotLauncher"])
    ],
    targets: [
        .executableTarget(
            name: "AstrbotLauncher",
            path: "Sources/AstrbotLauncher",
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
