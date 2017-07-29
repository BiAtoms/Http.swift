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
    
    open var prefix: String = ""
    open var middlewares: [MiddlewareHandler] = []
    
    open func add(_ route: inout Route) {
        let middlewares = self.middlewares + route.middlewares
        route = Route(method: route.method, path: prefix.appendingPathComponent(route.path), handler: route.handler)
        route.middlewares = middlewares
        routes.append(route)
    }
    
    open func group(_ prefix: String, middlewares: [MiddlewareHandler] = [],  code: () -> Void) {
        let prev = self.prefix
        self.prefix = self.prefix.appendingPathComponent(prefix)
        self.middlewares.append(contentsOf: middlewares)
        code()
        self.middlewares.removeLast(middlewares.count)
        self.prefix = prev
    }
}
