//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import CoreLocation
// import CoreTelephony
// import SystemConfiguration.CaptiveNetwork
import NetworkExtension

public class BreinUser {

    ///  user email
    var email: String!

    ///  user first name
    var firstName: String!

    //  user last name
    var lastName: String!

    //  user date of birth
    var dateOfBirth: String!

    //  user imei number
    var imei: String!

    //  user deviceId
    var deviceId: String!

    //  user sessionId
    var sessionId: String!

    // contains the userAgent in additional part
    var userAgent: String!

    // contains the referrer in additional part
    var referrer: String!

    // contains the url in additional part
    var url: String!

    // contains the url in additional part
    var ipAddress: String!

    // location coordinates
    var locationData: CLLocation?

    // contains localDateTime
    var localDateTime: String?

    /// contains timezone
    var timezone: String?

    /// contains additional dictionary
    var additional = [String: AnyObject]()

    /// contains user dictionary
    var userDic = [String: AnyObject]()
    

    /// Initializer with "nothing"
    public init() {
    }

    /// Initializer with email
    public init(email: String!) {
        setEmail(email)
    }

    /// returns the email
    public func getEmail() -> String! {
        return email
    }

    /// sets the email
    public func setEmail(email: String!) -> BreinUser! {
        self.email = email
        return self
    }

    /// returns the first name
    public func getFirstName() -> String! {
        return firstName
    }

    /// sets the first name
    public func setFirstName(firstName: String!) -> BreinUser! {
        self.firstName = firstName
        return self
    }

    /// returns the last name 
    public func getLastName() -> String! {
        return lastName
    }

    /// sets the last name 
    public func setLastName(lastName: String!) -> BreinUser! {
        self.lastName = lastName
        return self
    }

    /// returns the date of birth
    public func getDateOfBirth() -> String! {
        return dateOfBirth
    }

    /// sets the date of birth 
    public func setDateOfBirth(month: Int, day: Int, year: Int) -> BreinUser! {

        if case 1 ... 12 = month {
            if case 1 ... 31 = day {
                if case 1900 ... 2100 = year {
                    self.dateOfBirth = "\(month)/\(day)/\(year)"
                }
            }
        }
        return self
    }

    /// this will reset the value of dateOfBirth to ""
    public func resetDateOfBirth() {
        self.dateOfBirth = ""
    }

    public func getImei() -> String! {
        return imei
    }

    public func setImei(imei: String!) -> BreinUser! {
        self.imei = imei
        return self
    }

    public func getDeviceId() -> String! {
        return deviceId
    }

    public func setDeviceId(deviceId: String!) -> BreinUser! {
        self.deviceId = deviceId
        return self
    }

    public func getSessionId() -> String! {
        return sessionId
    }

    public func setSessionId(sessionId: String!) -> BreinUser! {
        self.sessionId = sessionId
        return self
    }

    public func setUserAgent(userAgent: String!) -> BreinUser! {
        self.userAgent = userAgent
        return self
    }

    public func setReferrer(referrer: String!) -> BreinUser! {
        self.referrer = referrer
        return self
    }

    public func getReferrer() -> String! {
        return referrer
    }

    public func setLocalDateTime(localDateTime: String!) -> BreinUser! {
        self.localDateTime = localDateTime
        return self
    }

    /// Get localDateTime if set
    /// In case if not set or empty the current localDateTime will be detected
    /// -return 
    public func getLocalDateTime() -> String! {

        if (self.localDateTime ?? "").isEmpty {
            return detectLocalDateTime()
        } 

        return localDateTime
    }

    public func setTimezone(timeZone: String!) -> BreinUser! {
        self.timezone = timeZone
        return self
    }

    /// get current time zone
    /// if not set or empty the current detected timezone will be returned
    /// - return 
    public func getTimezone() -> String! {

        if (self.timezone ?? "").isEmpty {
            return detectCurrentTimezone()
        }

        return timezone
    }

    public func setUrl(url: String!) -> BreinUser! {
        self.url = url
        return self
    }

    public func getUrl() -> String! {
        return url
    }

    public func setIpAddress(ipAddress: String!) -> BreinUser! {
        self.ipAddress = ipAddress
        return self
    }

    public func getIpAddress() -> String! {
        return ipAddress
    }

    public func setAdditional(key: String?, map: [String: AnyObject]?) -> BreinUser! {
        if map == nil {
            return self
        }
        if let pKey = key {

            var enhancedDic = [String: AnyObject]()
            enhancedDic[pKey] = map

            return setAdditionalDic(enhancedDic)
        }

        return self
    }

    /// sets the user.additional dic for additional fields within the user.additional structure
    public func setAdditionalDic(dic: [String: AnyObject]) -> BreinUser! {
        self.additional = dic
        return self
    }

    ///
    public func getAdditionalDic() -> [String: AnyObject]? {
        return additional
    }

    /// sets the user map for for additional fields
    public func setUserDic(map: [String: AnyObject]) -> BreinUser! {
        self.userDic = map
        return self
    }

    /// returns the optional user dic
    public func getUserDic() -> [String: AnyObject]? {
        return userDic
    }
    
    public func setLocationData(locationData: CLLocation?) -> BreinUser {
        self.locationData = locationData
        return self
    }

    public func detectCurrentTimezone() -> String! {
        let localTimeZoneName: String = NSTimeZone.localTimeZone().name
        // print("local time zone is: \(localTimeZoneName)")
        return localTimeZoneName
    }

    public func detectLocalDateTime() -> String! {
        let date = NSDate()

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ (z)"

        let defaultLocalDateTimeString = formatter.stringFromDate(date)

        // print("local time is: \(defaultLocalDateTimeStr)")
        return defaultLocalDateTimeString
    }

    ///
    public func prepareUserRequest(inout userData: [String: AnyObject], breinConfig: BreinConfig!) {

        if let dateOfBirth = self.getDateOfBirth() {
            userData["dateOfBirth"] = dateOfBirth
        }

        if let imei = self.getImei() {
            userData["imei"] = imei
        }

        if let deviceId = self.getDeviceId() {
            userData["deviceId"] = deviceId
        }

        if let email = self.getEmail() where !email.isEmpty {
            userData["email"] = self.getEmail()
        }

        if let session = self.getSessionId() where !session.isEmpty {
            userData["sessionId"] = self.getSessionId()
        }

        if let firstName = self.getFirstName() where !firstName.isEmpty {
            userData["firstName"] = firstName
        }

        if let user = self.getLastName() where !user.isEmpty {
            userData["lastName"] = user
        }

        // add possible further fields coming from user dictionary
        if let userDataDic = self.getUserDic() {
            if userDataDic.count > 0 {
                BreinMapUtil.fillMap(userDataDic, requestStructure: &userData)
            }
        }

        // only add if something is there
        if let addData = prepareAdditionalFields() {
            userData["additional"] = addData
        }
    }

    /// 
    public func prepareAdditionalFields() -> [String: AnyObject]! {

        // additional part
        var additionalData = [String: AnyObject]()
        if locationData != nil {
            // only a valid location will be taken into consideration
            // this is the case when the corrdiantes are different from 0
            if locationData?.coordinate.latitude != 0 {
                var locData = [String: AnyObject]()
                locData["accuracy"] = locationData?.horizontalAccuracy
                locData["latitude"] = locationData?.coordinate.latitude
                locData["longitude"] = locationData?.coordinate.longitude
                locData["speed"] = locationData?.speed

                additionalData["location"] = locData
            }
        }

        if let userAgentValue = self.getUserAgent() {
            additionalData["userAgent"] = userAgentValue
        }

        if let referrerValue = self.getReferrer() {
            additionalData["referrer"] = referrerValue
        }

        if let urlValue = self.getUrl() {
            additionalData["url"] = urlValue
        }

        /// use the one that may be defined
        if let localDateTimeValue = self.getLocalDateTime() {
            additionalData["localDateTime"] = localDateTimeValue
        }

        if let timezoneValue = self.getTimezone() {
            additionalData["timezone"] = timezoneValue
        }

        // add possible further fields coming from additional dictionary
        if let userAdditionalDataDic = self.getAdditionalDic() {
            if userAdditionalDataDic.count > 0 {
                BreinMapUtil.fillMap(userAdditionalDataDic, requestStructure: &additionalData)
            }
        }
        
        // prepareNetworkInfo(&additionalData)

        return additionalData
    }

    // provides networkinformation
    /*
    public func prepareNetworkInfo(inout requestStructure: [String: AnyObject]) {

        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        let name = carrier?.carrierName
        let mobileCountryCode = carrier?.mobileCountryCode
        
        let ssid = self.getSSID()

        let wifi = NEHotspotNetwork()
        dump(wifi)
       

        let st = "SSID：\(wifi.SSID)， BSSID：\(wifi.BSSID)， strength: \(wifi.signalStrength)， secure: \(wifi.secure)\n"
        
        let telInfo = CTTelephonyNetworkInfo()
        dump(telInfo)

        let networkSpeed =  telInfo.currentRadioAccessTechnology
        dump(networkSpeed)
    }
    */

    public func getUserAgent() -> String! {

        let userAgent: String = {
            if let info = NSBundle.mainBundle().infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let versionString: String

                    if #available(OSX 10.10, *) {
                        let version = NSProcessInfo.processInfo().operatingSystemVersion
                        versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    } else {
                        versionString = "10.9"
                    }

                    let osName: String = {
#if os(iOS)
                        return "iOS"
#elseif os(watchOS)
                        return "watchOS"
#elseif os(tvOS)
                        return "tvOS"
#elseif os(OSX)
                        return "OS X"
#elseif os(Linux)
                        return "Linux"
#else
                        return "Unknown"
#endif
                    }()

                    return "\(osName) \(versionString)"
                }()

                return "\(executable)/\(bundle) (\(version); \(osNameVersion))"
            }

            return "Breinify"
        }()


        return userAgent
    }

    /*
    func getSSID() -> String? {
        var ssid: String?
        var bsid: String?
        
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    bsid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
                    
                    break
                }
            }
        }
        return ssid
    }
    */

    public func description() -> String! {
        return (((((((((((((((("BreinUser details: "
                + "\r") + " name: ")
                + (self.firstName == nil ? "n/a" : self.firstName))
                + " ") + (self.lastName == nil ? "n/a" : self.lastName))
                + " email: ") + (self.email == nil ? "n/a" : self.email))
                + " dateOfBirth: ") + (self.dateOfBirth == nil ? "n/a" : self.dateOfBirth))
                + "\r") + " imei: ") + (self.imei == nil ? "n/a" : self.imei))
                + " deviceId: ") + (self.deviceId == nil ? "n/a" : self.deviceId))
                + "\r") + " sessionId: ") + (self.sessionId == nil ? "n/a" : self.sessionId)
    }
}
