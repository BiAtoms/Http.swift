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
        .package(url: "https://github.com/BiAtoms/Socket.swift.git", from: "2.2.0"),
        .package(url: "https://github.com/BiAtoms/Request.swift.git", from: "2.1.0"),
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
