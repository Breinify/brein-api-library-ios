//
// Created by Marco on 09.05.17.
// Copyright (c) 2017 Breinify. All rights reserved.
//

import Foundation
import BreinifyApi

open class BreinTemporalDataResult : BreinResult {

    static let kWheatherKey = "weather"
    static let kTimeKey = "time"
    static let kLocationKey = "location"
    static let kHolidayListKey = "holidays"
    static let kEventListKey = "events"

    // contains an array of dictionaries
    var dataList: [NSDictionary] = []

    public init(_ dataList: [NSDictionary]) {
        self.dataList = dataList

        // init with empty dictionary
        super.init(dictResult: NSDictionary())
    }

    public func getDataList() -> [NSDictionary] {
        return self.dataList
    }
}