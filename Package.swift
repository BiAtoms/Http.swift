import PackageDescription

let package = Package(
    name: "HttpSwift",
    dependencies: [
            .Package(url: "https://github.com/BiAtoms/Socket.swift.git", majorVersion: 1, minor: 3),
            //.Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4, minor: 4),
        ]
)
