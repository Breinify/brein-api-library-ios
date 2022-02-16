//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinHolidayResult: BreinTemporalDataResult {

    static let kHolidayTypesKey = "types"
    static let kHolidaySourceKey = "source"
    static let kHolidayNameKey = "holiday"
    static let kHolidayIdentifierKey = "holidays"

    public init(_ breinResult: BreinResult) {
        if let holidayDic = breinResult.get(BreinHolidayResult.kHolidayIdentifierKey) {
            super.init(holidayDic as! [NSDictionary])
        } else {
            super.init([NSDictionary]())
        }
    }

    public func getHolidayList() -> [NSDictionary] {
        getDataList()
    }

    public func getTypes(_ entry: NSDictionary) -> String? {

        if let newArr: NSArray = entry.object(forKey: BreinHolidayResult.kHolidayTypesKey) as? NSArray {
            let myArray = NSMutableArray(array: newArr)
            let stringList = myArray.componentsJoined(by: ",")
            return stringList
        }

        return nil
    }

    public func getSource(_ entry: NSDictionary) -> String? {
        entry.object(forKey: BreinHolidayResult.kHolidaySourceKey) as? String
    }

    public func getName(_ entry: NSDictionary) -> String? {
        entry.object(forKey: BreinHolidayResult.kHolidayNameKey) as? String
    }

}
