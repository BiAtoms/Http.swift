//
//  StaticServer.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/29/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

class StaticServer {
    static func serveFile(at path: String) throws -> Response {
        let file = File(path: path)
        if file.exists {
            return Response(.ok, body: file.bytes)
        }
        throw ServerError.httpRouteNotFound
    }
    
    static func serveFile(in directory: String, path: String) throws -> Response {
        let path = directory.expandingTildeInPath.appendingPathComponent(path)
        return try serveFile(at: path)
    }
}


private extension String {
    var expandingTildeInPath: String {
        return NSString(string: self).expandingTildeInPath
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return NSString(string: self).appendingPathComponent(str)
    }
}
