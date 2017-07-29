//
//  File.swift
//  HttpSwift
//
//  Created by Orkhan Alikhanov on 7/28/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

open class File {
    var path: String
    
    init(path: String) {
        self.path = path
    }
    
    var exists: Bool {
        var isDir: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && !isDir.boolValue
    }
    
    var `extension`: String {
        return NSString(string: path).pathExtension
    }
    
    var bytes: [Byte] {
        if exists {
            let data = NSData(contentsOfFile: path)!
            let b = UnsafePointer<Byte>(OpaquePointer(data.bytes))
            let s = UnsafeBufferPointer<Byte>(start: b, count: data.length)
            let bytes = [Byte](s)
            return bytes
        }
        return []
    }
}
