// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "HttpSwift",
    products: [
        .library(
            name: "HttpSwift",
            targets: ["HttpSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/BiAtoms/Socket.swift.git", .upToNextMinor(from: "2.4.0")),
        .package(url: "https://github.com/BiAtoms/Request.swift.git", .upToNextMinor(from: "2.3.0")),
    ],
    targets: [
        .target(
            name: "HttpSwift",
            dependencies: ["SocketSwift"],
            path: "Sources",
            exclude: ["Frameworks"]),
        .testTarget(
            name: "HttpSwiftTests",
            dependencies: ["HttpSwift", "RequestSwift"]),
    ]
)
