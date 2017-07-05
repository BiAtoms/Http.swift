//
//  Middleware.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/5/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

open class Middleware {
    open func handle(request: Request, closure: RouteHandler) throws -> Response {
        return try closure(request)
    }
}
