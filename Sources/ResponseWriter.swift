//
//  ResponseParser.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

//    HTTP/{version} {status-code} {reason-phrase}
//    {header}:{optional-whitespaces}{header-value}{optional-whitespaces}
//    .
//    .
//    .
//    {header}:{optional-whitespaces}{header-value}{optional-whitespaces}
//    {CRLF}
//    {body}

//    HTTP/1.1 200 OK
//    Date: Mon, 27 Jul 2009 12:28:53 GMT
//    Server: Apache
//    Content-Length: 51
//    Content-Type: text/plain
//
//    Hello World! My payload includes a trailing CRLF.

open class ResponseWriter {
    
    private let response: Response
    open var version: String {
        return "1.1"
    }
    required public init(response: Response) {
        self.response = response
    }
    
    open class func write(response: Response) -> [Byte] {
        return self.init(response: response).write()
    }
    
    open func write() -> [Byte] {
        let statusLine = buildStatusLine()
        response.prepareHeaders()
        let headerFields = buildHeaderFields()
        var raw: [Byte] = statusLine.bytes
        raw.append(contentsOf: headerFields.bytes)
        raw.append(contentsOf: "\r\n".bytes)
        raw.append(contentsOf: response.body)
        return raw
    }

    
    internal func buildStatusLine() -> String {
        return "HTTP/\(version) \(response.status.code) \(response.status.reason)\r\n"
    }
    
    internal func buildHeaderFields() -> String {
        var headerField = ""
        response.headers.forEach { (key, value) in
            headerField += "\(key): \(value)\r\n"
        }
        
        return headerField
    }
}

internal extension String {
    var bytes: [Byte] {
        return [Byte](self.utf8)
    }
}
