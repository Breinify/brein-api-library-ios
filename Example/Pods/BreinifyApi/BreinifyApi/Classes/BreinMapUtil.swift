//
// Created by Marco on 23.11.16.
//

import Foundation

public class BreinMapUtil {

    public typealias Dic = [String: AnyObject]

    public class func fillMap(dataMap: Dic, inout requestStructure: Dic ) {
        
        for (key,value) in dataMap {
            // print("\(key) = \(value)")

            if let dataDic = value as? Dic {
                var extra = Dic()
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