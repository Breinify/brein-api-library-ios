//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
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
        if let location = breinResult.get(BreinLocationResult.kLocationIdentifierKey) {
            super.init(dictResult: location as! NSDictionary)
        } else {
            super.init(dictResult: NSDictionary())
        }
    }

    public init(_ locationData: NSDictionary) {
        super.init(dictResult: locationData)
    }

    public func getCountry() -> String? {
        get(BreinLocationResult.kCountryKey) as? String
    }

    public func getState() -> String? {
        get(BreinLocationResult.kStateKey) as? String
    }

    public func getCity() -> String? {
        get(BreinLocationResult.kCityKey) as? String
    }

    public func getGranularity() -> String? {
        get(BreinLocationResult.kGranularityKey) as? String
    }

    public func getLatitude() -> Double? {
        let value = get(BreinLocationResult.kLatKey)
        return BreinUtil.getDoubleValue(value)
    }

    public func getLongitude() -> Double? {
        let value = get(BreinLocationResult.kLonKey)
        return BreinUtil.getDoubleValue(value)
    }

    public func getZipCode() -> String? {
        get(BreinLocationResult.kZipCode) as? String
    }

}
