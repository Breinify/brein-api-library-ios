//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinResult {

    var dic = NSDictionary()

    init(dictResponse: NSDictionary) {
        dic = dictResponse
    }

    func get(key: String) -> AnyObject! {
        return dic.objectForKey(key)
    }

    func getDictionary() -> NSDictionary {
        return dic
    }
}
