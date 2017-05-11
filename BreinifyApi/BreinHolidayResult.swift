//
// Created by Marco on 28.04.17.
//


import Foundation

open class BreinHolidayResult : BreinTemporalDataResult {

    static let kHolidayTypesKey = "types"
    static let kHolidaySourceKey = "source"
    static let kHolidayNameKey = "holiday"
    static let kHolidayIdentifierKey = "holidays"

    // contains an array of dictionaries
    // var holidayList: [NSDictionary] = []
    
    public init(_ breinResult: BreinResult) {
        let holidayDic = breinResult.get(BreinHolidayResult.kHolidayIdentifierKey)
        print("Holidays are: \(holidayDic)")

        super.init(holidayDic as! [NSDictionary])

        // self.dataList = holidayDic as! [NSDictionary]
    }

    public func getHolidayList() -> [NSDictionary] {
        return self.getDataList()
    }

    public func getTypes(_ entry : NSDictionary) -> String {
    
        if let newArr : NSArray = entry.object(forKey: BreinHolidayResult.kHolidayTypesKey) as? NSArray {
            let yourArray = NSMutableArray(array: newArr)
            print("\(yourArray)")
            let stringList = yourArray.componentsJoined(by: ",")
            return stringList
        }
        
        return ""
    }

    public func getSource(_ entry : NSDictionary) -> String {
        return entry.object(forKey: BreinHolidayResult.kHolidaySourceKey) as! String
    }

    public func getName(_ entry : NSDictionary) -> String {
        return entry.object(forKey: BreinHolidayResult.kHolidayNameKey) as! String
    }
    
}