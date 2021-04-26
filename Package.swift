// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hlsinfo",
    dependencies: [
        .package(
            url: "https://github.com/comcast/mamba.git",
            .exact(Version(1, 5, 1))
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .exact(Version(0, 4, 2))
        ),
    ],
    targets: [
        .target(
            name: "hlsinfo",
            dependencies: [
                .product(name: "mamba", package: "mamba"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "hlsinfoTests",
            dependencies: ["hlsinfo"]
        )
    ]
)
