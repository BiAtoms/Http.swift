import PackageDescription

let package = Package(
    name: "HttpSwift",
    dependencies: [
            .Package(url: "https://github.com/BiAtoms/Socket.swift.git", majorVersion: 2, minor: 0),
            .Package(url: "https://github.com/BiAtoms/Request.swift.git", majorVersion: 2, minor: 0),//for tests
        ]
)
