//
// Created by Marco on 28.04.17.
//

import Foundation

open class BreinLocationResult {

    static let kStateKey = "state"
    static let kCityKey = "city"
    static let kGranularityKey = "granularity"
    static let kGeoJsonKey = "geojson"

    static let kLatKey = "lat"
    static let kLonKey = "lon"

    var country: String?
    var state: String?
    var city: String?
    var granularity: String?
    var lat: Double?
    var lon: Double?
    
    //var geoJsons:[String, AnyObject]?
    // private final Map<String, Map<String, Object>> geojsons;

    public init() {

    }

    public func getCountry() -> String? {
        return country
    }

    public func getState() -> String? {
        return state
    }

    public func getCity() -> String? {
        return city
    }

    public func getLatitude() -> Double? {
        return lat
    }

    public func getLongitude() -> Double? {
        return lon
    }
    

}

