//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

open class BreinResult {

    var dic = NSDictionary()

    public init(dictResponse: NSDictionary) {
        dic = dictResponse
    }

    public func get(_ key: String) -> AnyObject? {
        return dic.object(forKey: key) as AnyObject?
    }

    public func getDictionary() -> NSDictionary {
        return dic
    }
    
}
