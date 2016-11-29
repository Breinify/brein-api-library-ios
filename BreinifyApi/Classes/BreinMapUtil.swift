//
// Created by Marco on 23.11.16.
//

import Foundation

public class BreinMapUtil {

    public typealias Map = [String: AnyObject]

    public class func fillMap(dataMap: Map, inout requestStructure: Map ) {

        // TODO: Implementation missing...
        // Loop over dataMap
        // add value
        // if Dictionary -> call fillMap again

        for (key,value) in dataMap {
            print("\(key) = \(value)")

            if let dataDic = value as? Map {
                var extra = Map()
                fillMap(dataDic, requestStructure: &extra)
                if extra.count > 0 {
                    requestStructure[key] = extra
                }
            } else {
                requestStructure[key] = value
            }
        }
    }
}