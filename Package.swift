// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthenticationKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v15),
        .macOS(SupportedPlatform.MacOSVersion.v12),
        .tvOS(SupportedPlatform.TVOSVersion.v15),
        .watchOS(SupportedPlatform.WatchOSVersion.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AuthenticationKit",
            targets: ["AuthenticationKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/hrietmann/StringKit.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AuthenticationKit",
            dependencies: ["StringKit"]),
        .testTarget(
            name: "AuthenticationKitTests",
            dependencies: ["AuthenticationKit"]),
    ]
)
