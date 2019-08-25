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


public typealias MiddlewareHandler = (_ request: Request, _ closure: RouteHandler) throws -> Response
open class Server {
    open let queue = DispatchQueue(label: "com.biatoms.server-swift." + UUID().uuidString)
    open var router = Router()
    open var socket: Socket!
    open var errorHandler: ErrorHandler.Type = ErrorHandler.self
    open var middlewares: [MiddlewareHandler] = []
    
    public init() {}
    public var tlsConfig: TLS.Configuration?
    
    #if os(Linux)
    public typealias CertificatePath = (path: URL, keyPath: URL, password: String?)
    #else
    public typealias CertificatePath = (path: URL, password: String)
    #endif
    
    open func run(port: SocketSwift.Port = 8080, address: String? = nil, certifiatePath: CertificatePath? = nil)	 throws {
            if let path = certifiatePath {
                #if os(Linux)
                    let cert = TLS.importCert(at: path.path, withKey: path.keyPath, password: path.password)
                    try TLS.initialize()
                #else
                    let cert = TLS.importCert(at: path.path, password: path.password)
                #endif
                tlsConfig = TLS.Configuration(certificate: cert)
            }
        socket = try Socket.tcpListening(port: port, address: address)
        queue.async { [weak self] in
            guard let self = self else {return}
            while let client = try? self.socket.accept() {
                self.handleConnection(client)
                client.close()
            }
        }
    }
    
    open func handleConnection(_ client: Socket) {
        if let config = tlsConfig {
            do {
                try client.startTls(config)
            } catch {
                print("Failed to establish secure connection", error)
                return
            }
        }
        
        
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
                print("Connection error", error)
            }
        }
    }
    
    open func getResponse(_ request: Request) throws -> Response {
        let response = try Helper.goingThrough(middlewares: middlewares, request: request) { try self.router.respond(to: $0) }
        return response
    }
    
    open func stop() {
        socket?.close()
    }
    
    deinit {
        stop()
    }
    
    @discardableResult
    public func custom(_ method: String, _ path: String, handler: @escaping RouteHandler) -> Route {
        var route = Route(method: method, path: path, handler: handler)
        router.add(&route)
        return route
    }
    
    public func group(_ prefix: String, middlewares: [MiddlewareHandler] = [],  code: () -> Void) {
        router.group(prefix, middlewares: middlewares, code: code)
    }
    
    public func files(in directory: String) {
        self.get("{path}") {
            return try StaticServer.serveFile(in: directory, path: $0.routeParams["path"]!)
        }
    }
    
    public func fileBrowser(in directory: String) {
        self.get("{path}") {
            return try StaticServer.fileBrowser(in: directory, path: $0.routeParams["path"]!)
        }
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
