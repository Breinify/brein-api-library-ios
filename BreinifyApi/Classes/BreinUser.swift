//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import CoreTelephony
import NetworkExtension

open class BreinUser {

    /// user email
    var email: String!

    /// user first name
    var firstName: String!

    /// user last name
    var lastName: String!

    ///  user date of birth
    var dateOfBirth: String!

    ///  user imei number
    var imei: String!

    /// user deviceId
    var deviceId: String!

    /// user sessionId
    var sessionId: String!

    /// an ID (e.g. UUID) used to identify the user
    /// this is the case for instance if the email is not set
    var userId: String!

    /// contains the userAgent in additional part
    var userAgent: String!

    /// contains the referrer in additional part
    var referrer: String!

    /// contains the url in additional part
    var url: String!

    /// contains the url in additional part
    var ipAddress: String!

    /// location coordinates
    var locationData: CLLocation?

    /// contains localDateTime
    var localDateTime: String?

    /// contains timezone
    var timezone: String?

    /// contains the deviceToken
    var deviceToken: String?

    /// contains additional dictionary
    var additional = [String: AnyObject]()

    /// contains user dictionary
    var userDic = [String: AnyObject]()

    /// contains network.ssid
    var nw_ssid = ""

    /// contains network.bsid
    var nw_bssid = ""

    /// contains network.macaddress
    var nw_macadr = ""

    /// contains network.carrier name
    var nw_carrier = ""
    
    /// Initializer with "nothing"
    public init() {
    }

    /// Initializer with email
    public init(email: String!) {
        self.email = email
    }

    /// Initializer with firstName and lastName
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    /// returns the email
    public func getEmail() -> String? {
        return email
    }

    /// sets the email
    @discardableResult
    public func setEmail(_ email: String!) -> BreinUser! {
        self.email = email
        return self
    }

    /// returns the first name
    public func getFirstName() -> String? {
        return firstName
    }

    /// sets the first name
    @discardableResult
    public func setFirstName(_ firstName: String!) -> BreinUser! {
        self.firstName = firstName
        return self
    }

    /// returns the last name
    public func getLastName() -> String? {
        return lastName
    }

    /// sets the last name
    @discardableResult
    public func setLastName(_ lastName: String!) -> BreinUser! {
        self.lastName = lastName
        return self
    }

    /// returns the date of birth
    public func getDateOfBirth() -> String! {
        return dateOfBirth
    }

    /// sets the date of birth
    @discardableResult
    public func setDateOfBirth(_ month: Int, day: Int, year: Int) -> BreinUser! {

        if case 1 ... 12 = month {
            if case 1 ... 31 = day {
                if case 1900 ... 2100 = year {
                    self.dateOfBirth = "\(month)/\(day)/\(year)"
                }
            }
        }
        return self
    }

    /// set date of birth as string
    @discardableResult
    public func setDateOfBirthString(_ birth: String!) {
        self.dateOfBirth = birth
    }

    /// this will reset the value of dateOfBirth to ""
    public func resetDateOfBirth() {
        self.dateOfBirth = ""
    }

    /// returns imei
    public func getImei() -> String? {
        return imei
    }

    /// sets imei
    @discardableResult
    public func setImei(_ imei: String!) -> BreinUser! {
        self.imei = imei
        return self
    }

    /// returns deviceId
    public func getDeviceId() -> String! {
        return deviceId
    }

    /// sets deviceId
    @discardableResult
    public func setDeviceId(_ deviceId: String!) -> BreinUser! {
        self.deviceId = deviceId
        return self
    }

    /// returns sessionId
    public func getSessionId() -> String! {
        return sessionId
    }

    /// sets sessionId
    @discardableResult
    public func setSessionId(_ sessionId: String!) -> BreinUser! {
        self.sessionId = sessionId
        return self
    }

    /// returns userId
    public func getUserId() -> String! {
        return self.userId
    }

    /// sets userId
    @discardableResult
    public func setUserId(_ userId: String!) -> BreinUser! {
        self.userId = userId
        return self
    }

    /// sets userAgent
    @discardableResult
    public func setUserAgent(_ userAgent: String!) -> BreinUser! {
        self.userAgent = userAgent
        return self
    }

    /// sets referrer
    @discardableResult
    public func setReferrer(_ referrer: String!) -> BreinUser! {
        self.referrer = referrer
        return self
    }

    /// returns refferer
    public func getReferrer() -> String? {
        return referrer
    }

    /// sets localDateTime
    @discardableResult
    public func setLocalDateTime(_ localDateTime: String!) -> BreinUser! {
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

    /// sets timezone
    @discardableResult
    public func setTimezone(_ timeZone: String!) -> BreinUser! {
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

    /// set deviceToken
    @discardableResult
    public func setDeviceToken(_ deviceToken: String!) -> BreinUser! {
        self.deviceToken = deviceToken
        return self
    }

    /// returns deviceToken
    public func getDeviceToken() -> String! {
        return self.deviceToken
    }

    /// sets url
    @discardableResult
    public func setUrl(_ url: String!) -> BreinUser! {
        self.url = url
        return self
    }

    /// returns url
    public func getUrl() -> String! {
        return url
    }

    /// sets ipAddress
    @discardableResult
    public func setIpAddress(_ ipAddress: String!) -> BreinUser! {
        self.ipAddress = ipAddress
        return self
    }

    /// gets ipAddress
    public func getIpAddress() -> String! {
        return ipAddress
    }

    /// sets additional dic
    @discardableResult
    public func setAdditional(_ key: String?, map: [String: AnyObject]?) -> BreinUser! {
        if map == nil {
            return self
        }
        if map!.isEmpty {
            return self
        }
        if let pKey = key {
            var enhancedDic = [String: AnyObject]()
            enhancedDic[pKey] = map as AnyObject?

            return setAdditionalDic(enhancedDic)
        }

        return self
    }

    /// clear additional dictionary
    public func clearAdditional() -> BreinUser! {
        return setAdditionalDic([:])
    }

    /// sets the user.additional dic for additional fields within the user.additional structure
    @discardableResult
    public func setAdditionalDic(_ dic: [String: AnyObject]) -> BreinUser! {
        self.additional = dic
        return self
    }

    /// returns addtional dic
    public func getAdditionalDic() -> [String: AnyObject]? {
        return self.additional
    }

    /// sets the user map for for additional fields
    @discardableResult
    public func setUserDic(_ map: [String: AnyObject]) -> BreinUser! {
        self.userDic = map
        return self
    }

    /// returns the optional user dic
    public func getUserDic() -> [String: AnyObject]? {
        return self.userDic
    }

    /// sets location data
    @discardableResult
    public func setLocationData(_ locationData: CLLocation?) -> BreinUser {
        self.locationData = locationData
        return self
    }

    /// detect current timezone
    public func detectCurrentTimezone() -> String! {
        let localTimeZoneName: String = NSTimeZone.local.identifier
        // print("local time zone is: \(localTimeZoneName)")
        return localTimeZoneName
    }

    /// detect current localDateTime
    public func detectLocalDateTime() -> String! {
        let date = Date()

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone.current
        //  "localDateTime" : "Sun Apr 23 2017 18:15:48 GMT-0800 (PST)",
        //  formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ (zz)"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ (zz)"


        let defaultLocalDateTimeString = formatter.string(from: date as Date)

        // print("local time is: \(defaultLocalDateTimeStr)")
        return defaultLocalDateTimeString
    }

    /// prepares user related map for json request
    public func prepareUserRequest(_ userData: inout [String: AnyObject], breinConfig: BreinConfig!) {

        if let dateOfBirth = self.getDateOfBirth() {
            userData["dateOfBirth"] = dateOfBirth as AnyObject?
        }

        if let imei = self.getImei() {
            userData["imei"] = imei as AnyObject?
        }

        if let deviceId = self.getDeviceId() {
            userData["deviceId"] = deviceId as AnyObject?
        }

        if let email = self.getEmail() {
            userData["email"] = email as AnyObject?
        }

        if let session = self.getSessionId() {
            userData["sessionId"] = session as AnyObject?
        }

        if self.getUserId() == nil {
            self.setUserId(UUID().uuidString)
        }

        if let userid = self.getUserId() {
            userData["userId"] = userid as AnyObject?
        }

        if let firstName = self.getFirstName() {
            userData["firstName"] = firstName as AnyObject?
        }

        if let user = self.getLastName() {
            userData["lastName"] = user as AnyObject?
        }

        // add possible further fields coming from user dictionary
        if let userDataDic = self.getUserDic() {
            if userDataDic.count > 0 {
                BreinMapUtil.fillMap(userDataDic, requestStructure: &userData)
            }
        }

        // only add if something is there
        if let addData = prepareAdditionalFields() {
            userData["additional"] = addData as AnyObject?
        }
    }

    /// prepares user.additional map for json request
    public func prepareAdditionalFields() -> [String: AnyObject]! {

      
        // additional part
        var additionalData = [String: AnyObject]()
        if self.locationData != nil {
            // only a valid location will be taken into consideration
            // this is the case when the corrdiantes are different from 0
            if locationData?.coordinate.latitude != 0 {
                var locData = [String: AnyObject]()
                locData["accuracy"] = locationData?.horizontalAccuracy as AnyObject?
                locData["latitude"] = locationData?.coordinate.latitude as AnyObject?
                locData["longitude"] = locationData?.coordinate.longitude as AnyObject?
                locData["speed"] = locationData?.speed as AnyObject?

                additionalData["location"] = locData as AnyObject?
            }
        }

        if let userAgentValue = self.getUserAgent() {
            additionalData["userAgent"] = userAgentValue as AnyObject?
        }

        if let referrerValue = self.getReferrer() {
            additionalData["referrer"] = referrerValue as AnyObject?
        }

        if let urlValue = self.getUrl() {
            additionalData["url"] = urlValue as AnyObject?
        }

        /// use the one that may be defined
        if let localDateTimeValue = self.getLocalDateTime() {
            additionalData["localDateTime"] = localDateTimeValue as AnyObject?
        }

        if let timezoneValue = self.getTimezone() {
            additionalData["timezone"] = timezoneValue as AnyObject?
        }

        // deviceToken for pushNotifications
        if let devToken = self.getDeviceToken() {
            var identifierData = [String: AnyObject]()
            identifierData["iosPushDeviceToken"] = devToken as AnyObject?
            additionalData["identifiers"] = identifierData as AnyObject?
        }

        // ipAddress
        if let additionalIpAddress = self.getIpAddress() {
            additionalData["ipAddress"] = additionalIpAddress as AnyObject?
        }

        // add possible further fields coming from additional dictionary
        if let userAdditionalDataDic = self.getAdditionalDic() {
            if userAdditionalDataDic.count > 0 {
                BreinMapUtil.fillMap(userAdditionalDataDic, requestStructure: &additionalData)
            }
        }

        // detect network
        detectNetworkInfo()

        var network = [String: AnyObject]()
        if nw_ssid.characters.count > 0 {
            network["ssid"] = nw_ssid as AnyObject?
        }

        if nw_bssid.characters.count > 0 {
            network["bssid"] = nw_bssid as AnyObject?
        }

        if nw_macadr.characters.count > 0 {
            network["macAddress"] = nw_macadr as AnyObject?
        }
        if network.count > 0 {
            additionalData["network"] = network as AnyObject?
        }
        
        return additionalData
    }

    /**
     * Creates a clone of a given BreinUser object
     *
     * @param sourceUser contains the original brein user
     * @return a copy of the original brein user
     */
    public static func clone(_ sourceUser: BreinUser?) -> BreinUser {
        
        if let orgUser = sourceUser {

            // then a new user with the new created brein user request
            let newUser = BreinUser()
                    .setEmail(orgUser.getEmail())
                    .setFirstName(orgUser.getFirstName())
                    .setLastName(orgUser.getLastName())
                    .setImei(orgUser.getImei())
                    .setDeviceId(orgUser.getDeviceId())
                    .setUrl(orgUser.getUrl())
                    .setSessionId(orgUser.getSessionId())
                    .setImei(orgUser.getImei())
                    .setUserAgent(orgUser.getUserAgent())
                    .setReferrer(orgUser.getReferrer())
                    .setIpAddress(orgUser.getIpAddress())
                    .setLocalDateTime(orgUser.getLocalDateTime())
                    .setTimezone(orgUser.getTimezone())
                    .setUserId(orgUser.getUserId())
                    .setDeviceToken(orgUser.getDeviceToken())

            newUser?.setDateOfBirthString(orgUser.getDateOfBirth())

            // copy dictionaries
            if let clonedAdditionalDic = orgUser.getAdditionalDic() {
                let _ = newUser?.setAdditionalDic(clonedAdditionalDic)
            }

            if let clonedUserDic = orgUser.getUserDic() {
                let _ = newUser?.setUserDic(clonedUserDic)
            }

            return newUser!
        }

        return BreinUser()
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

    /// returns user agent
    public func getUserAgent() -> String! {

        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                var model = UIDevice.current.model
                if model == "iPod" {
                    model = "iPhone"
                }

                let osNameVersion: String = {
                    let versionString: String

                    if #available(OSX 10.10, *) {
                        let version = ProcessInfo.processInfo.operatingSystemVersion
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

                return "\(executable)/\(bundle) (\(version); \(osNameVersion); \(model))"
            }

            return "Breinify"
        }()


        return userAgent
    }

    func detectNetworkInfo() {

        /// init
        nw_ssid = ""
        nw_bssid = ""
        nw_macadr = ""
        nw_carrier = ""

        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    nw_ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as! String
                    nw_bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as! String
                    // print(interfaceInfo)
                    break
                }
            }
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if networkInfo != nil {
            // print(networkInfo)
            // e.g. CTRadioAccessTechnologyEdge
            let radio = networkInfo.currentRadioAccessTechnology

            let carrier = networkInfo.subscriberCellularProvider
            if carrier != nil {
                // print(carrier)

                // something like 1&1
                nw_carrier = carrier?.carrierName as String!
                // let mobileCountryCode = carrier?.mobileCountryCode
            }

        }
        // MAC Address is not supported by Apple. Instead this should be
        // used:
        nw_macadr = UIDevice.current.identifierForVendor?.uuidString as String!
        // print(uid)

    }

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
