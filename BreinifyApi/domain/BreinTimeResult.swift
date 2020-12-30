//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation
import BreinifyApi

open class BreinTimeResult: BreinResult {

    static let kLocalMinute = "localMinute"
    static let kLocalMonth = "localMonth"
    static let kLocalHour = "localHour"
    static let kLocalYear = "localYear"
    static let kLocalSecond = "localSecond"
    static let kLocalDayName = "localDayName"
    static let kLocalDay = "localDay"
    static let kLocalFormatIso8601 = "localFormatIso8601"
    static let kEpochMonth = "epochMonth"
    static let kEpochHour = "epochHour"
    static let kEpochDay = "epochDay"
    static let kEpochYear = "epochYear"
    static let kEpochMinute = "epochMinute"
    static let kEpochDayName = "epochDayName"
    static let kEpoch = "epoch"
    static let kEpochSecond = "epochSecond"
    static let kEpochFormatIso8601 = "epochFormatIso8601"
    static let kTimezone = "timezone"

    public init(_ breinResult: BreinResult) {
        if let timeDic = breinResult.get("time") {
            super.init(dictResult: timeDic as! NSDictionary)
        } else {
            super.init(dictResult: NSDictionary())
        }
    }

    public func getLocalMinute() -> Int? {
        self.get(BreinTimeResult.kLocalMinute) as? Int
    }

    public func getLocalMonth() -> Int? {
        self.get(BreinTimeResult.kLocalMonth) as? Int
    }

    public func getLocalHour() -> Int? {
        self.get(BreinTimeResult.kLocalHour) as? Int
    }

    public func getLocalYear() -> Int? {
        self.get(BreinTimeResult.kLocalYear) as? Int
    }

    public func getLocalSecond() -> Int? {
        self.get(BreinTimeResult.kLocalSecond) as? Int
    }

    public func getLocalDayName() -> String? {
        self.get(BreinTimeResult.kLocalDayName) as? String
    }

    public func getLocalDay() -> Int? {
        self.get(BreinTimeResult.kLocalDay) as? Int
    }

    public func getLocalFormatIso8601() -> String? {
        self.get(BreinTimeResult.kLocalFormatIso8601) as? String
    }

    public func getEpochMinute() -> Int? {
        self.get(BreinTimeResult.kEpochMinute) as? Int
    }

    public func getEpochMonth() -> Int? {
        self.get(BreinTimeResult.kEpochMonth) as? Int
    }

    public func getEpochHour() -> Int? {
        self.get(BreinTimeResult.kEpochHour) as? Int
    }

    public func getEpochYear() -> Int? {
        self.get(BreinTimeResult.kEpochYear) as? Int
    }

    public func getEpochSecond() -> Int? {
        self.get(BreinTimeResult.kEpochSecond) as? Int
    }

    public func getEpochDayName() -> String? {
        self.get(BreinTimeResult.kEpochDayName) as? String
    }

    public func getEpochDay() -> Int? {
        self.get(BreinTimeResult.kEpochDay) as? Int
    }

    public func getEpochFormatIso8601() -> String? {
        self.get(BreinTimeResult.kEpochFormatIso8601) as? String
    }

    public func getTimezone() -> String? {
        self.get(BreinTimeResult.kTimezone) as? String
    }
}
