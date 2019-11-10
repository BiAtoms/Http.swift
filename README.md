[![Platform Linux](https://img.shields.io/badge/platform-linux-brightgreen.svg)](#)
[![Platform](https://img.shields.io/cocoapods/p/Http.swift.svg?style=flat)](https://github.com/BiAtoms/Http.swift)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Http.swift.svg)](https://cocoapods.org/pods/Http.swift)
[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/github/license/BiAtoms/Http.swift.svg)](https://github.com/BiAtoms/Http.swift/blob/master/LICENSE)
[![Build Status - Master](https://travis-ci.org/BiAtoms/Http.swift.svg?branch=master)](https://travis-ci.org/BiAtoms/Http.swift)


# Http.swift

A tiny HTTP server engine written in swift.

## Features
* SSL/TLS support
* Error handling
* Global middlewares
* Route middlewares
* Route grouping
* File serving
* Directory browsing
* Request parameters
* Works in Linux, iOS, macOS and tvOS

```swift
import HttpSwift
// ...
let server = Server()
server.get("/hello/{id}") { request in
    print(request.queryParams["state"])
    return .ok(request.routeParams["id"]!) 
}

try server.run() //go to http://localhost:8080/hello/1?state=active in the browser
```

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Http.swift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
target '<Your Target Name>' do
  pod 'Http.swift', '~> 2.2.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Http.swift into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "BiAtoms/Http.swift" ~> 2.2.0
```

Run `carthage update` to build the framework and drag the built `HttpSwift.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Http.swift does support its use on supported platforms. 

Once you have your Swift package set up, adding Http.swift as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/BiAtoms/Http.swift.git", from: "2.2.0")
]
```

## Authors

* **Orkhan Alikhanov** - *Initial work* - [OrkhanAlikhanov](https://github.com/OrkhanAlikhanov)

See also the list of [contributors](https://github.com/BiAtoms/Http.swift/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/BiAtoms/Http.swift/blob/master/LICENSE) file for details
