//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
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
        self.getDataList()
    }

    public func getStartTime() -> Double? {
        self.get(BreinEventResult.kStartTimeKey) as! Double?
    }

    public func getEndTime() -> Double? {
        self.get(BreinEventResult.kEndTimeKey) as! Double?
    }

    public func getName() -> String? {
        self.get(BreinEventResult.kNameKey) as! String?
    }

    public func getSize() -> Int? {
        self.get(BreinEventResult.kSizeKey) as! Int?
    }

    public func getCategory() -> Double? {
        self.get(BreinEventResult.kCategoryKey) as! Double?
    }

    public func getLocationResult() -> BreinLocationResult {
        let locDic = self.get(BreinEventResult.kLocationKey) as! NSDictionary
        let locObject = BreinLocationResult(locDic)
        return locObject
    }

}