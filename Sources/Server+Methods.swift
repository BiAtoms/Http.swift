//
//  Server+Methods.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/28/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

extension Server {
    @discardableResult
    public func get(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("GET", path, handler: handler)
    }
    
    @discardableResult
    public func post(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("POST", path, handler: handler)
    }
    
    @discardableResult
    public func head(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("HEAD", path, handler: handler)
    }
    
    @discardableResult
    public func put(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("PUT", path, handler: handler)
    }
    
    @discardableResult
    public func patch(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("PATCH", path, handler: handler)
    }
    
    @discardableResult
    public func delete(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("DELETE", path, handler: handler)
    }
    
    @discardableResult
    public func trace(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("TRACE", path, handler: handler)
    }
    
    @discardableResult
    public func connect(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("CONNECT", path, handler: handler)
    }
    
    @discardableResult
    public func options(_ path: String, handler: @escaping RouteHandler) -> Route {
        return custom("OPTIONS", path, handler: handler)
    }
}
