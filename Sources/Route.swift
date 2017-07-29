//
//  Route.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

public typealias RouteHandler = (Request) throws -> Response
open class Route {
    open let method: String
    open let path: String
    open let paramNames: [String]
    open let regexPattern: String
    open let handler: RouteHandler
    open var middlewares: [MiddlewareHandler] = []
    
    public init(method: String, path: String, handler: @escaping RouteHandler) {
        self.method = method
        self.path = "/".appendingPathComponent(path)
        self.handler = handler
        
        self.paramNames = try! Regex.matches(path, pattern: "\\{(.+?)\\}")
        self.regexPattern = try! Regex.replace(path, pattern: "\\{.+?\\}", with: "\\(\\.\\+\\)\\/\\?").replacingOccurrences(of: "/", with: "\\/")
        
    }
    
    open func getResponse(_ request: Request) throws -> Response {
        let response = try Helper.goingThrough(middlewares: middlewares, request: request) { try self.handler($0) }
        return response
    }
    
    @discardableResult
    open func middleware(_ handler: @escaping MiddlewareHandler) -> Route {
        self.middlewares.append(handler)
        return self
    }
}
