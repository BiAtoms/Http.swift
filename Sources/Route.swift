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
    
    public init(method: String, path: String, handler: @escaping RouteHandler) {
        self.method = method
        self.path = path
        self.handler = handler
        
        self.paramNames = try! Regex.matches(path, pattern: "\\{(.+?)\\}")
        self.regexPattern = try! Regex.replace(path, pattern: "\\{.+?\\}", with: "\\(\\.\\+\\)\\/\\?").replacingOccurrences(of: "/", with: "\\/")
        
    }
}
