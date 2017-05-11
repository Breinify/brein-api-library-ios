//
// Created by Marco on 28.04.17.
//

import Foundation

open class BreinLocationResult: BreinResult {

    static let kCountryKey = "country"
    static let kStateKey = "state"
    static let kCityKey = "city"
    static let kGranularityKey = "granularity"
    static let kGeoJsonKey = "geojson"
    static let kLocationIdentifierKey = "location"
    static let kLatKey = "lat"
    static let kLonKey = "lon"
    static let kZipCode = "zipCode"

    public init(_ breinResult: BreinResult) {
        let location = breinResult.get(BreinLocationResult.kLocationIdentifierKey)
        print("Location is: \(location)")
        super.init(dictResult: location as! NSDictionary)
    }

    public init(_ locationData: NSDictionary) {
        super.init(dictResult: locationData)
    }

    public func getCountry() -> String? {
        return self.get(BreinLocationResult.kCountryKey) as! String
    }

    public func getState() -> String? {
        return self.get(BreinLocationResult.kStateKey) as! String
    }

    public func getCity() -> String? {
        return self.get(BreinLocationResult.kCityKey) as! String
    }

    public func getGranularity() -> String? {
        return self.get(BreinLocationResult.kGranularityKey) as! String
    }

    public func getLatitude() -> Double? {
        return self.get(BreinLocationResult.kLatKey) as! Double
    }

    public func getLongitude() -> Double? {
        return self.get(BreinLocationResult.kLonKey) as! Double
    }

    public func getZipCode() -> String? {
        return self.get(BreinLocationResult.kZipCode) as! String
    }

}

