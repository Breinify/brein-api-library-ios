//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinResult {

    var dic = NSDictionary()

    public init(dictResult: NSDictionary) {
        dic = dictResult
    }

    public func setDictionary(_ dictionary: NSDictionary) {
        dic = dictionary
    }

    public func get(_ key: String) -> Any? {
        dic.object(forKey: key) as Any?
    }

    public func getDictionary() -> NSDictionary {
        dic
    }

    public func getResult() -> String {
        "result"
    }
}
