//
//  HttpRequest.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

public typealias HeaderDictionary = [String: String]
public typealias ParamDictionary = [String: String]
import Foundation
import SocketSwift

open class Request {
    open var method: String
    open var fullPath: String
    open var version: String
    open var headers: HeaderDictionary
    open var body: [Byte]
    
    open var path: String {
        return fullPath.split("?", maxSplits: 1)[0]
    }
    open var queryString: String {
        let arr = fullPath.split("?", maxSplits: 1)
        return arr.count == 2 ? arr[1] : ""
    }
    
    open lazy var queryParams: ParamDictionary = {
        return Url.decode(self.queryString)
    }()
    
    open var routeParams: ParamDictionary = [:]
    
    public init(method: String, fullPath: String, version: String, headers: HeaderDictionary, body: [Byte]) {
        self.method = method
        self.fullPath = fullPath
        self.version = version
        self.headers = headers
        self.body = body
    }
    
    
    open func matches(route: Route) -> Bool {
        if route.method != self.method {
            return false
        }
        let params =  try! Regex.matches(path, pattern: route.regexPattern)
        if params.count > 0 {
            if params.count != route.paramNames.count { // this should not happen actually
                return false
            }            
            zip(route.paramNames, params).forEach {
                routeParams[$0] = $1
            }
            
            return true
        }
        return self.path == route.path
    }
}

extension String {
    static var contentLength: String {
        return "Content-Length"
    }
}


