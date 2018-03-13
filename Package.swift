import PackageDescription

let package = Package(
    name: "HttpSwift",
    dependencies: [
            .Package(url: "https://github.com/BiAtoms/Socket.swift.git", majorVersion: 2, minor: 2),
            .Package(url: "https://github.com/BiAtoms/Request.swift.git", majorVersion: 2, minor: 1), // for tests
        ]
)
