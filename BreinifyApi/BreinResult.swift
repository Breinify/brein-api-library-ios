//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
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

    public func get(_ key: String) -> AnyObject? {
        return self.dic.object(forKey: key) as AnyObject?
    }

    public func getDictionary() -> NSDictionary {
        return self.dic
    }

}
