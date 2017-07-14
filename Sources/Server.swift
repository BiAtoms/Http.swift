//
//  Server.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Dispatch
import Foundation
import SocketSwift

open class Server {
    open let queue = DispatchQueue(label: "com.biatoms.server-swift." + UUID().uuidString)
    open var router = Router()
    open var socket: Socket!
    open var errorHandler: ErrorHandler.Type = ErrorHandler.self
    open var middlewares: [Middleware] = []
    
    open func run(port: SocketSwift.Port = 8080, address: String? = nil) {
        queue.async {
            self.socket = try! Socket.tcpListening(port: port, address: address)
            while let client = try? self.socket.accept() {
                self.handleConnection(client)
                client.close()
            }
        }
    }
    
    open func handleConnection(_ client: Socket) {
        var request: Request!
        do {
            request = try RequestParser.parse(socket: client)
            let response = try getResponse(request)
            try client.write(response)
        } catch {
            do {
                let response = errorHandler.onError(request: request, error: error) ?? .internalServerError(error)
                try client.write(response)
            } catch {
                print(error)
            }
        }
    }
    
    open func getResponse(_ request: Request) throws -> Response {
        var i = 0
        
        func next() throws -> RouteHandler? {
            if i == middlewares.count {
                return nil
            }
            let copied = i
            i += 1
            return { req in
                return try self.middlewares[copied].handle(request: req, closure: try next() ?? self.router.getRoute(for: req).handler)
            }
        }
        
        return try next()?(request) ?? router.respond(to: request)
    }
    
    open func stop() {
        socket?.close()
    }
    
    deinit {
        stop()
    }
}


extension Server {
    public func get(_ path: String, handler: @escaping RouteHandler) {
        custom("GET", path, handler: handler)
    }
    
    public func post(_ path: String, handler: @escaping RouteHandler) {
        custom("POST", path, handler: handler)
    }
    
    public func custom(_ method: String, _ path: String, handler: @escaping RouteHandler) {
        router.routes.append(Route(method: method, path: path, handler: handler))
    }
}


private extension Socket {
     func write(_ response: Response) throws {
        let raw = ResponseWriter.write(response: response)
        try raw.withUnsafeBufferPointer {
            try self.write($0.baseAddress!, length: $0.count)
        }
    }
}

private extension Response {
    class func internalServerError(_ error: Error?) -> Self {
        return self.init(.internalServerError, body: error?.localizedDescription.bytes ?? [])
    }
}
