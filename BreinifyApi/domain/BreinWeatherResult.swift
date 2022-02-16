//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinWeatherResult: BreinResult {

    static let kDescriptionKey = "description"
    static let kTemperatureKey = "temperature"
    static let kTemperatureFahrenheitKey = "temperatureF"
    static let kTemperatureCelsiusKey = "temperatureC"
    static let kPrecipitationKey = "precipitation"
    static let kPrecipitationTypeKey = "precipitationType"
    static let kPrecipitationAmountKey = "precipitationAmount"
    static let kWindStrengthKey = "windStrength"
    static let kLastMeasuredKey = "lastMeasured"
    static let kCloudCoverKey = "cloudCover"
    static let KMeasuredLocationKey = "measuredAt"

    static let kLatitudekey = "lat"
    static let kLongitudeKey = "lon"

    public init(_ breinResult: BreinResult) {
        if let weather = breinResult.get(BreinTemporalDataResult.kWheatherKey) {
            super.init(dictResult: weather as! NSDictionary)
        } else {
            super.init(dictResult: NSDictionary())
        }
    }

    public func getDescription() -> String? {
        get(BreinWeatherResult.kDescriptionKey) as? String
    }

    public func getTemperature() -> Double? {
        let value = get(BreinWeatherResult.kTemperatureKey)
        return BreinUtil.getDoubleValue(value)
    }

    public func getTemperatureCelsius() -> Double? {
        let value = get(BreinWeatherResult.kTemperatureCelsiusKey)
        return BreinUtil.getDoubleValue(value)
    }

    public func getTemperatureFahrenheit() -> Double? {
        let value = get(BreinWeatherResult.kTemperatureFahrenheitKey)
        return BreinUtil.getDoubleValue(value)
    }

    public func getTemperatureKelvin() -> Double? {
        if let celsius = getTemperatureCelsius() {
            return celsius + 273.15
        }
        return nil
    }

    public func getCloudCover() -> Int? {
        get(BreinWeatherResult.kCloudCoverKey) as? Int
    }

    public func getWindStrength() -> Double? {
        get(BreinWeatherResult.kWindStrengthKey) as? Double
    }

    public func getLastMeasured() -> Int? {
        get(BreinWeatherResult.kLastMeasuredKey) as? Int
    }

    public func getPrecipitationType() -> String? {
        if let preDic = get(BreinWeatherResult.kPrecipitationKey) as? NSDictionary {
            if let preType = preDic.object(forKey: BreinWeatherResult.kPrecipitationTypeKey) {
                return preType as? String
            }
        }

        return nil
    }

    public func getPrecipitationAmount() -> Int? {
        if let preDic = get(BreinWeatherResult.kPrecipitationKey) as? NSDictionary {
            if let preAmount = preDic.object(forKey: BreinWeatherResult.kPrecipitationAmountKey) {
                return preAmount as? Int
            }
        }

        return nil
    }
}
