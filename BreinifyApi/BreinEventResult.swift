//
// Created by Marco on 28.04.17.
//

import Foundation

open class BreinEventResult: BreinTemporalDataResult {

    static let kNameKey = "displayName"
    static let kStartTimeKey = "startTime"
    static let kEndTimeKey = "endTime"
    static let kCategoryKey = "category"
    static let kSizeKey = "sizeEstimated"

    public init(_ breinResult: BreinResult) {

        if let eventList = breinResult.get(BreinTemporalDataResult.kEventListKey) {
            super.init(eventList as! [NSDictionary])
        } else {
            super.init([NSDictionary]())
        }
    }

    public init(_ eventDic: NSDictionary) {

        // empty array of Dictionaries
        super.init([NSDictionary]())

        setDictionary(eventDic)
    }

    public func getEventList() -> [NSDictionary] {
        return self.getDataList()
    }

    public func getStartTime() -> Double? {
        return self.get(BreinEventResult.kStartTimeKey) as! Double?
    }

    public func getEndTime() -> Double? {
        return self.get(BreinEventResult.kEndTimeKey) as! Double?
    }

    public func getName() -> String? {
        return self.get(BreinEventResult.kNameKey) as! String?
    }

    public func getSize() -> Int? {
        return self.get(BreinEventResult.kSizeKey) as! Int?
    }

    /*
    public func getCategory() -> Double? {
        return self.get(BreinEventResult.kEndTimeKey) as! Double?
    }
    */

    public func getLocationResult() -> BreinLocationResult {
        let locDic = self.get(BreinEventResult.kLocationKey) as! NSDictionary
        let locObject = BreinLocationResult(locDic)
        return locObject
    }

}