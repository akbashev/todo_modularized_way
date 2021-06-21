// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YATA",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "Todo", targets: ["Todo"]),
        .library(name: "Todos", targets: ["Todos"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git",  from: "0.19.0")
    ],
    targets: [
        .target(
            name: "SharedModels",
            dependencies: []
        ),
        .target(
            name: "Todo",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Todos",
            dependencies: [
                "SharedModels",
                "Todo",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
