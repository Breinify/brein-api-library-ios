//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinResult {

    var dic = NSDictionary()

    public init(dictResult: NSDictionary) {
        self.dic = dictResult
    }

    public func setDictionary(_ dictionary: NSDictionary) {
        self.dic = dictionary
    }

    public func get(_ key: String) -> Any? {
        self.dic.object(forKey: key) as Any?
    }

    public func getDictionary() -> NSDictionary {
        self.dic
    }

    public func getResult() -> String {
        return "result"
    }
}
