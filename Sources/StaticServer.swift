//
//  StaticServer.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/29/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

open class StaticServer {
    open static func serveFile(at path: String) throws -> Response {
        let file = File(path: path)
        if file.exists {
            return Response(.ok, body: file.bytes)
        }
        throw ServerError.httpRouteNotFound
    }
    
    open static func serveFile(in directory: String, path: String) throws -> Response {
        let path = directory.expandingTildeInPath.appendingPathComponent(path)
        return try serveFile(at: path)
    }
    
    open static func fileBrowser(in directory: String, path subpath: String) throws -> Response {
        let path = directory.expandingTildeInPath.appendingPathComponent(subpath)
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: path) {
            return renderBrowser(for: subpath, content: contents)
        }
        return try serveFile(at: path)
    }
    
    open static func renderBrowser(for path: String, content: [String]) -> Response {
        func wrap(_ tag: String, newLine: Bool = true, attrs: [String: String] = [:], _ content: () -> String) -> String {
            return "<\(tag)\(attrs.reduce("") { $0 + " \($1.key)=\"\($1.value)\"" })>\(newLine ? "\n" : "")\(content())</\(tag)>\n"
        }
        
        let title = "Index Of: \(path)"
        let body = "<!DOCTYPE html>\n" +
            wrap("html") {
                wrap("head") {
                    wrap("title", newLine: false) { title }
                    }
                    + wrap("body") {
                        wrap("h1") { title }
                            + wrap("table") {
                                wrap("tbody") {
                                    content.reduce("") { r, name in
                                        r + wrap("tr") {
                                            wrap("td") {
                                                wrap("a", newLine: false, attrs: ["href": path.appendingPathComponent(name)]) { name }
                                            }
                                        
                                    }
                                }
                            }
                        }
                        
                }
        }
        
        
        return .ok(body)
    }
    
}


internal extension String {
    var expandingTildeInPath: String {
        return NSString(string: self).expandingTildeInPath
    }
    
    func appendingPathComponent(_ str: String) -> String {
        let endsWith = self.hasSuffix("/")
        let beginsWith = str.hasPrefix("/")
        if !endsWith && !beginsWith {
            return self + "/" + str
        } else if (endsWith && !beginsWith) || (beginsWith && !endsWith) {
            return self + str
        }
        
        return self[..<self.index(before: self.endIndex)] + str
    }
}
