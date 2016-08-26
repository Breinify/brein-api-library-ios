//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinResult {

    var dic = NSDictionary()

    public init(dictResponse: NSDictionary) {
        dic = dictResponse
    }

    public func get(key: String) -> AnyObject! {
        return dic.objectForKey(key)
    }

    public func getDictionary() -> NSDictionary {
        return dic
    }
}
