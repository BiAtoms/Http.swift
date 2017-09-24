//
//  Regex.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

open class Regex {
    open class func replace(_ string: String, pattern: String, with template: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        return regex.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count), withTemplate: template)
    }
    
    open class func matches(_ string: String, pattern: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count))
        var matches = [String]()
        let string = NSString(string: string) //for NSString.substring
        results.forEach { result in
            (1..<result.numberOfRanges).forEach {
                matches.append(string.substring(with: result.range(at: $0)))
            }
        }
        return matches
    }
}
