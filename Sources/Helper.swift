//
//  Helper.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/29/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

class Helper {
    static func goingThrough(middlewares: [MiddlewareHandler], request: Request, lastHandler: @escaping RouteHandler) throws -> Response {
        var i = 0
        func next() throws -> RouteHandler {
            if i == middlewares.count {
                return lastHandler
            }
            let copied = i
            i += 1
            return { req in
                return try middlewares[copied](req, try next())
            }
        }

        return try next()(request)
    }
}
