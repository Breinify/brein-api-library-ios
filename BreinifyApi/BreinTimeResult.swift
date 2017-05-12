//
// Created by Marco on 12.05.17.
// Copyright (c) 2017 Breinify. All rights reserved.
//

import Foundation

open class BreinTimeResult : BreinResult {

    static let kLocalMinute = "localMinute"
    static let kLocalMonth = "localMonth"
    static let kLocalHour = "localHour"
    static let kLocalYear = "localYear"
    static let kLocalSecond = "localSecond"
    static let kLocalDayName = "localDayName"
    static let kLocalDay = "localDay"
    static let kLocalFormatIso8601 = "localFormatiso8601"
    static let kEpochMonth = "epochMonth"
    static let kEpochHour = "epochHour"
    static let kEpochDay = "epochDay"
    static let kEpochYear = "epochYear"
    static let kEpochMinute = "epochMinute"
    static let kEpochDayName = "epochDayName"
    static let kEpoch = "epoch"
    static let kEpochSecond = "epochSecond"
    static let kEpochFormatIso8601 = "epochFormatiso8601"
    static let kTimezone = "timezone"
    
    public init(_ breinResult: BreinResult) {
        let timeDic = breinResult.get("time")
        print("TimeDic is: \(timeDic)")
        super.init(dictResult: timeDic as! NSDictionary)
    }
    
    public func getLocalMinute() -> Int? {
        return self.get(BreinTimeResult.kLocalMinute) as! Int?
    }

    public func getLocalMonth() -> Int? {
        return self.get(BreinTimeResult.kLocalMonth) as! Int?
    }

    public func getLocalHour() -> Int? {
        return self.get(BreinTimeResult.kLocalHour) as! Int?
    }

    public func getLocalYear() -> Int? {
        return self.get(BreinTimeResult.kLocalYear) as! Int?
    }

    public func getLocalSecond() -> Int? {
        return self.get(BreinTimeResult.kLocalSecond) as! Int?
    }

    public func getLocalDayName() -> String? {
        return self.get(BreinTimeResult.kLocalDayName) as! String?
    }

    public func getLocalDay() -> String? {
        return self.get(BreinTimeResult.kLocalDay) as! String?
    }

    public func getLocalFormatIso8601() -> String? {
        return self.get(BreinTimeResult.kLocalFormatIso8601) as! String?
    }
    
    public func getEpochMinute() -> Int? {
        return self.get(BreinTimeResult.kEpochMinute) as! Int?
    }

    public func getEpochMonth() -> Int? {
        return self.get(BreinTimeResult.kEpochMonth) as! Int?
    }

    public func getEpochHour() -> Int? {
        return self.get(BreinTimeResult.kEpochHour) as! Int?
    }

    public func getEpochYear() -> Int? {
        return self.get(BreinTimeResult.kEpochYear) as! Int?
    }

    public func getEpochSecond() -> Int? {
        return self.get(BreinTimeResult.kEpochSecond) as! Int?
    }

    public func getEpochDayName() -> String? {
        return self.get(BreinTimeResult.kEpochDayName) as! String?
    }

    public func getEpochDay() -> String? {
        return self.get(BreinTimeResult.kEpochDay) as! String?
    }

    public func getEpochFormatIso8601() -> String? {
        return self.get(BreinTimeResult.kEpochFormatIso8601) as! String?
    }

    public func getTimezone() -> String? {
        return self.get(BreinTimeResult.kTimezone) as! String?
    }
    
}