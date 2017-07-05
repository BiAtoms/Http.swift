//
//  HttpParser.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

//    {method} {fullPath} HTTP/{version}
//    {header}:{optional-whitespaces}{header-value}{optional-whitespaces}
//    .
//    .
//    .
//    {header}:{optional-whitespaces}{header-value}{optional-whitespaces}
//    {CRLF}
//    {body}

//    POST /hello HTTP/1.1
//    Host: www.example.com
//    Content-Length: 51
//    Content-Type: text/plain
//
//    Hello World!
import SocketSwift

open class RequestParser {
    private let socket: Socket
    
    required public init(socket: Socket) {
        self.socket = socket
    }
    
    open class func parse(socket: Socket) throws -> Request {
        return try self.init(socket: socket).parse()
    }
    
   open  func parse() throws -> Request {
        let (method, fullPath, version) = try parseRequestLine()
        let headers = parseHeaders()
        var body = [Byte]()
        if let value = headers[.contentLength], let length = Int(value) {
            body = try parseBody(length)
        }
        
        return Request(method: method, fullPath: fullPath, version: version, headers: headers, body: body)
    }
    
    internal func parseRequestLine() throws -> (method: String, fullPath: String, version: String) {
        let requestLine = try socket.readLine()
        let parts = requestLine.split(" ", maxSplits: 2)
        return (parts[0], parts[1], String(parts[2].characters.dropFirst("HTTP/".characters.count)) )
    }
    
    internal func parseHeaders() -> HeaderDictionary {
        var headers = HeaderDictionary()
        while let line = try? socket.readLine() {
            let parts = line.split(":", maxSplits: 1)
            let (key, value) = (parts[0].trimmingCharacters(in: .whitespaces), parts[1].trimmingCharacters(in: .whitespaces))
            headers[key] = value
        }
        return headers
    }
    
    internal func parseBody(_ lenght: Int) throws -> [Byte] {
        var body = [Byte]()
        for _ in 0..<lenght { body.append(try socket.read()) }
        return body
    }
}

internal extension String {
    func split(_ separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [String] {
        return self.characters.split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
    }
}
