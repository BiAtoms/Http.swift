//
//  Router.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

open class Router {
    open var routes = [Route]()
    
    open func respond(to request: Request) throws -> Response {
        return try getRoute(for: request).getResponse(request)
    }
    
    open func getRoute(for request: Request) throws -> Route {
        for route in routes {
            if request.matches(route: route) {
                return route
            }
        }
        throw ServerError.httpRouteNotFound
    }
}
