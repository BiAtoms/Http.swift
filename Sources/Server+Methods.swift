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
}
