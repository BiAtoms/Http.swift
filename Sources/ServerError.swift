//
//  ServerError.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/5/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

public enum ServerError: Error {
    case httpRouteNotFound
    case emptyLine
}

import SocketSwift

extension Socket {
    open func readLine() throws -> String {
        var line: String = "" //yep it is StringBuilder
        let CR = Byte(13), LF = Byte(10)
        while let byte = try? read(), byte != LF {
            if byte != CR {
                line.append(Character(UnicodeScalar(byte)))
            }
        }
        if line.isEmpty {
            throw ServerError.emptyLine
        }
        
        return line
    }
}
