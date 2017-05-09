//
// Created by Marco on 23.11.16.
//

import Foundation

public class BreinMapUtil {

    public typealias Dic = [String: AnyObject]

    public class func fillMap(_ dataMap: Dic, requestStructure: inout Dic ) {
        
        for (key, value) in dataMap {
            // print("\(key) = \(value)")

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
