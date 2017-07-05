//
//  Tests.swift
//  HttpSwiftTests
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import XCTest
import SocketSwift
import Alamofire
@testable import HttpSwift


class HttpSwiftTests: XCTestCase {
    
    struct a {
        static let server: Server = {
            let server = Server()
            server.run()
            return server
        }()
        static let client = SessionManager.default
    }
    
    var port = Port(8080)
    var server: Server {
        return a.server
    }
    var client: SessionManager {
        return a.client
    }
    
    func testRoute() {
        let route = Route(method: "", path: "/api/{param1}/{param2}/next/{param3}", handler: {_ in return Response(.ok, body: [])})
        XCTAssertEqual(route.paramNames, ["param1", "param2", "param3"])
        
        let pattern = "(.+)\\/?"
        XCTAssertEqual(route.regexPattern, "\\/api\\/\(pattern)\\/\(pattern)\\/next\\/\(pattern)")
    }
    
    func testRequestAndResponse() {
        let data = "Hello World"
        let queryParams = ["string": "salam əıoueəiöü",
                           "number": "123"]
        let responseString = "TestPassed"
        let ex = expectation(description: "test")
        server.post("/hello/{id}/{name}/next/{part}") { request in
            XCTAssertEqual(request.method, "POST")
            XCTAssertEqual(request.path, "/hello/23/hi/next/second")
            XCTAssertEqual(request.routeParams, ["id": "23", "name": "hi", "part": "second"])
            XCTAssertEqual(request.queryParams, queryParams)
            XCTAssertTrue(request.headers.contains([
                "Host": "localhost:8080",
                "Content-Type": "text/plain",
                "Content-Length": "\(data.bytes.count)"
                ]))
            XCTAssertEqual(request.body, data.bytes)
            return .ok(responseString)
        }
        
        client.request("/hello/23/hi/next/second",
                       method: .post,
                       parameters: queryParams, encoding: data,
                       headers: ["Content-Type": "text/plain"]).responseString { r in
                        
                        XCTAssertTrue(r.response!.contains(["Server": "Http.swift"]))
                        XCTAssertEqual(r.value, responseString)
                        ex.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testResponseExceptions() {
        let ex = expectation(description: "httpRouteNotDefined")
        client.request("/aNonDefinedRoute").response { r in
            XCTAssertEqual(r.response?.statusCode, 404)
            ex.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    
    
}
private extension SessionManager {
    func request(_ url: String,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        let baseUrl = "http://localhost:8080"
        let url: URLConvertible = baseUrl + url
        return self.request(url,
                            method: method,
                            parameters: parameters,
                            encoding: encoding,
                            headers: headers)
    }
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request = try URLEncoding.queryString.encode(request, with: parameters)
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}


extension Dictionary where Value: Equatable {
    func contains(_ other: Dictionary<Key, Value>) -> Bool {
        for key in other.keys {
            if !self.keys.contains(key) || self[key]! != other[key]! {
                return false
            }
        }
        return true
    }
}


extension HTTPURLResponse {
    func contains(_ headers: [String:String]) -> Bool {
        return self.allHeaderFields.reduce([String:String]()) {
            var a = $0
            a[$1.key as! String] = $1.value as? String
            return a
            }.contains(headers)
    }
}
