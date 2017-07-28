//
//  Server+Methods.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/28/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

extension Server {
    public func get(_ path: String, handler: @escaping RouteHandler) {
        custom("GET", path, handler: handler)
    }
    
    public func post(_ path: String, handler: @escaping RouteHandler) {
        custom("POST", path, handler: handler)
    }
    
    public func head(_ path: String, handler: @escaping RouteHandler) {
        custom("HEAD", path, handler: handler)
    }
    
    public func put(_ path: String, handler: @escaping RouteHandler) {
        custom("PUT", path, handler: handler)
    }
    
    public func patch(_ path: String, handler: @escaping RouteHandler) {
        custom("PATCH", path, handler: handler)
    }
    
    public func delete(_ path: String, handler: @escaping RouteHandler) {
        custom("DELETE", path, handler: handler)
    }
    
    public func trace(_ path: String, handler: @escaping RouteHandler) {
        custom("TRACE", path, handler: handler)
    }
    
    public func connect(_ path: String, handler: @escaping RouteHandler) {
        custom("CONNECT", path, handler: handler)
    }
    
    public func options(_ path: String, handler: @escaping RouteHandler) {
        custom("OPTIONS", path, handler: handler)
    }
}
