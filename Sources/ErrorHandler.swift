//
//  ErrorHandler.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/5/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

open class ErrorHandler {
    public init() { }
    open class func onError(request: Request?, error: Error) -> Response? {
        if let error = error as? ServerError {
            if error == .httpRouteNotFound {
                return Response(.notFound, body: "Route \(request!.path) is not defined".bytes)
            }
        }
        
        return nil
    }
}
