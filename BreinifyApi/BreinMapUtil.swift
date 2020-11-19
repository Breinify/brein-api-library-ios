//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

public class BreinMapUtil {

    public typealias Dic = [String: AnyObject]

    public class func fillMap(_ dataMap: Dic, requestStructure: inout Dic ) {
        for (key, value) in dataMap {
            if let dataDic = value as? Dic {
                var extra = Dic()
                fillMap(dataDic, requestStructure: &extra)
                if extra.count > 0 {
                    requestStructure[key] = extra as AnyObject?
                }
            } else {
                requestStructure[key] = value
            }
        }
    }
}
