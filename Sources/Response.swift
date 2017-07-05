//
//  HttpResponse.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//
public typealias Byte = UInt8
open class Response {
    open var status: Status
    open var headers: HeaderDictionary
    open var body: [Byte]
    
    required public init(_ status: Status, body: [Byte] = [], headers: HeaderDictionary = [:]) {
        self.status = status
        self.headers = headers
        self.body = body
    }
    
   public struct Status {
        let code: Int
        let reason	: String
        
        private init(_ code: Int, _ reason: String) {
            self.code = code
            self.reason = reason
        }
        static func custom(_ code: Int, _ reason: String = "") -> Status {
            return Status(code, reason)
        }
        
        static let ok = Status(200, "OK")
        static let internalServerError = Status(500, "Internal Server Error")
        static let httpVersionNotSupported = Status(505, "HTTP Version Not Supported")
        static let notFound = Status(404, "Not Found")
    }
    
    internal func prepareHeaders() {
        headers["Server"] = "Http.swift"
        if body.count > 0 {
            headers[.contentLength] = "\(body.count)"
        }
    }
}


extension Response {
    convenience init(_ status: Status, body: String, headers: HeaderDictionary = [:]) {
        self.init(status, body: body.bytes, headers: headers)
    }
    
    class func ok(_ body: String, headers: HeaderDictionary = [:]) -> Self {
        return self.init(.ok, body: body.bytes, headers: headers)
    }
}
