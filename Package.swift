// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "localizable",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v4),
        .tvOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Localizable",
            targets: ["Localizable"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Incetro/observer-list.git", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Localizable",
            dependencies: [
                .product(name: "ObserverList", package: "observer-list")
            ]
        ),
        .testTarget(
            name: "LocalizableTests",
            dependencies: ["Localizable"]),
    ]
)
