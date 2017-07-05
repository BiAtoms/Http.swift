//
//  Url.swift
//  Http.swift
//
//  Created by Orkhan Alikhanov on 7/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

open class Url {
    open class func decode(_ url: String) -> ParamDictionary {
        var url = url.replacingOccurrences(of: "+", with: " ")
        if let r = url.removingPercentEncoding { url = r }
        
        var params = ParamDictionary()
        let keyValues = url.split("&")
        keyValues.forEach { keyValue in
            let pair = keyValue.split("=", maxSplits: 1)
            //if splitted string misses `=` for some reason (eg. example.com/api?test), we put empty string as its value
            let (key, value) = (pair[0], pair.count == 2 ? pair[1] : "")
            params[key] = value
        }
        
        return params
    }
}
