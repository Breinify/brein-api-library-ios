//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
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

    /// phone 
    var phone: String?

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

    /// contains additional.location dictionary
    var additionalLocation = [String: AnyObject]()

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
        firstName
    }

    /// sets the first name
    @discardableResult
    public func setFirstName(_ firstName: String!) -> BreinUser! {
        self.firstName = firstName
        return self
    }

    /// returns the last name
    public func getLastName() -> String? {
        lastName
    }

    /// sets the last name
    @discardableResult
    public func setLastName(_ lastName: String!) -> BreinUser! {
        self.lastName = lastName
        return self
    }

    /// returns the date of birth
    public func getDateOfBirth() -> String! {
        dateOfBirth
    }

    /// sets the date of birth
    @discardableResult
    public func setDateOfBirth(_ month: Int, day: Int, year: Int) -> BreinUser! {
        if case 1...12 = month {
            if case 1...31 = day {
                if case 1900...2100 = year {
                    self.dateOfBirth = "\(month)/\(day)/\(year)"
                }
            }
        }
        return self
    }

    /// set date of birth as string
    public func setDateOfBirthString(_ birth: String!) {
        self.dateOfBirth = birth
    }

    /// this will reset the value of dateOfBirth to ""
    public func resetDateOfBirth() {
        self.dateOfBirth = ""
    }

    /// returns imei
    public func getImei() -> String? {
        imei
    }

    /// sets imei
    @discardableResult
    public func setImei(_ imei: String!) -> BreinUser! {
        self.imei = imei
        return self
    }

    /// returns deviceId
    public func getDeviceId() -> String! {
        deviceId
    }

    /// sets deviceId
    @discardableResult
    public func setDeviceId(_ deviceId: String!) -> BreinUser! {
        self.deviceId = deviceId
        return self
    }

    /// returns sessionId
    public func getSessionId() -> String! {
        sessionId
    }

    /// sets sessionId
    @discardableResult
    public func setSessionId(_ sessionId: String!) -> BreinUser! {
        self.sessionId = sessionId
        return self
    }

    /// returns userId
    public func getUserId() -> String! {
        self.userId
    }

    /// sets userId
    @discardableResult
    public func setUserId(_ userId: String!) -> BreinUser! {
        self.userId = userId
        return self
    }

    /// returns phone
    public func getPhone() -> String! {
        self.phone
    }

    /// sets phone
    @discardableResult
    public func setPhone(_ phone: String!) -> BreinUser! {
        self.phone = phone
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
        referrer
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
        self.deviceToken
    }

    /// sets url
    @discardableResult
    public func setUrl(_ url: String!) -> BreinUser! {
        self.url = url
        return self
    }

    /// returns url
    public func getUrl() -> String! {
        url
    }

    /// sets ipAddress
    @discardableResult
    public func setIpAddress(_ ipAddress: String!) -> BreinUser! {
        self.ipAddress = ipAddress
        return self
    }

    /// gets ipAddress
    public func getIpAddress() -> String! {
        ipAddress
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
        setAdditionalDic([:])
    }

    /// sets the user.additional dic for additional fields within the user.additional structure
    @discardableResult
    public func setAdditionalDic(_ dic: [String: AnyObject]) -> BreinUser! {
        self.additional = dic
        return self
    }

    /// returns additional dic
    public func getAdditionalDic() -> [String: AnyObject]? {
         self.additional
    }

    /// sets the user map for for additional fields
    @discardableResult
    public func setUserDic(_ map: [String: AnyObject]) -> BreinUser! {
        self.userDic = map
        return self
    }

    /// returns the optional user dic
    public func getUserDic() -> [String: AnyObject]? {
        self.userDic
    }

    /// sets the user.additional dic for additional fields within the user.additional structure
    @discardableResult
    public func setAdditionalLocationDic(_ dic: [String: AnyObject]) -> BreinUser! {
        self.additionalLocation = dic
        return self
    }

    /// returns the additionalLocationDic
    public func getAdditionalLocationDic() -> [String: AnyObject]? {
        self.additionalLocation
    }

    /// set an additional location entry in location dictionry
    public func setAdditionalLocationEntry(key: String, value: AnyObject) -> BreinUser {
        self.additionalLocation[key] = value
        return self
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
        let stringFromDate = Date().breinifyFormat
        return stringFromDate
    }

    /// prepares user related map for json request
    public func prepareUserRequest(_ userData: inout [String: AnyObject], breinConfig: BreinConfig!) {

        if let dateOfBirth = BreinUtil.containsValue(self.getDateOfBirth()) {
            userData["dateOfBirth"] = dateOfBirth as AnyObject?
        }

        if let imei = BreinUtil.containsValue(self.getImei()) {
            userData["imei"] = imei as AnyObject?
        }

        if let deviceId = BreinUtil.containsValue(self.getDeviceId()) {
            userData["deviceId"] = deviceId as AnyObject?
        }

        if let email = BreinUtil.containsValue(self.getEmail()) {
            userData["email"] = email as AnyObject?
        }

        if let session = BreinUtil.containsValue(self.getSessionId()) {
            userData["sessionId"] = session as AnyObject?
        }

        if let userid = BreinUtil.containsValue(self.getUserId()) {
            userData["userId"] = userid as AnyObject?
        }

        if let phone = BreinUtil.containsValue(self.getPhone()) {
            userData["phone"] = phone as AnyObject?
        }

        if let firstName = BreinUtil.containsValue(self.getFirstName()) {
            userData["firstName"] = firstName as AnyObject?
        }

        if let user = BreinUtil.containsValue(self.getLastName()) {
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

        // location Data
        var locData = [String: AnyObject]()

        // check location values
        if self.locationData != nil {
            // only a valid location will be taken into consideration
            // this is the case when the corrdinates are different from 0
            if locationData?.coordinate.latitude != 0 {
                locData["accuracy"] = locationData?.horizontalAccuracy as AnyObject?
                locData["latitude"] = locationData?.coordinate.latitude as AnyObject?
                locData["longitude"] = locationData?.coordinate.longitude as AnyObject?
                locData["speed"] = locationData?.speed as AnyObject?
            }
        }

        // loop thru locationDic 
        for (key, value) in self.additionalLocation {
            // print("\(key) = \(value)")
            locData[key] = value
        }

        if locData.count > 0 {
            additionalData["location"] = locData as AnyObject?
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
        if nw_ssid.count > 0 {
            network["ssid"] = nw_ssid as AnyObject?
        }

        if nw_bssid.count > 0 {
            network["bssid"] = nw_bssid as AnyObject?
        }

        if nw_macadr.count > 0 {
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

            if let clonedAdditionalLocDic = orgUser.getAdditionalLocationDic() {
                let _ = newUser?.setAdditionalLocationDic(clonedAdditionalLocDic)
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


        /// TEST TEST TEST
//        let telephonyInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
//
//
//        var carrierNetwork = telephonyInfo.serviceCurrentRadioAccessTechnology?.first?.value ?? "null"
//        carrierNetwork = carrierNetwork.replacingOccurrences(of: "CTRadioAccessTechnology", with: "", options: NSString.CompareOptions.literal, range: nil)
//
//        let carrier = telephonyInfo.serviceSubscriberCellularProviders?.first?.value
//
//        let countryCode = carrier?.mobileCountryCode ?? "null"
//        let mobileNetworkName = carrier?.mobileNetworkCode ?? "null"
//        let carrierName = carrier?.carrierName ?? "null"
//        let isoCountryCode = carrier?.isoCountryCode?.uppercased() ?? "null"

        ///

        /*
        let telephonyInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        let carriers = networkInfo.serviceSubscriberCellularProviders?.values
        let result = carriers?.map { ($0.mobileNetworkCode, $0.mobileCountryCode) }
        BreinLogger.shared.debug("Carrier result is: \(String(describing: result))")
        */
        
        /// TODO: collect provider
        /// nw_carrier = xxxx


        // print(networkInfo)
        // e.g. CTRadioAccessTechnologyEdge
//        _ = networkInfo.serviceCurrentRadioAccessTechnology
//
//        if let carrier = networkInfo.serviceSubscriberCellularProviders {
//            // something like 1&1
//
//            let nw_carrier = carrier.carrierName ?? "null"
//
//            // let mobileCountryCode = carrier?.mobileCountryCode
//        }


        // MAC Address is not supported by Apple. Instead this should be
        // used:
        if let value = UIDevice.current.identifierForVendor?.uuidString {
            nw_macadr = value
        }

    }

    /*
    func getTelephonyInfo() -> String? {
        let networkInfo = CTTelephonyNetworkInfo()

        let currCarrierType: String?
        if #available(iOS 12.0, *) {

            let serviceSubscriberCellularProviders = networkInfo.serviceSubscriberCellularProviders

            // get curr value:
            guard let dict = networkInfo.serviceCurrentRadioAccessTechnology else {
                return nil
            }
            // as apple states
            // https://developer.apple.com/documentation/coretelephony/cttelephonynetworkinfo/3024510-servicecurrentradioaccesstechnol
            // 1st value is our string:
            let key = dict.keys.first! // Apple assures is present...

            // use it on previous dict:
            let carrierType = dict[key]

            // to compare:
            guard networkInfo.currentRadioAccessTechnology != nil else {
                return nil
            }
            currCarrierType = carrierType

        } else {
            // Fall back to pre iOS12
            guard let carrierType = networkInfo.currentRadioAccessTechnology else {
                return nil
            }
            currCarrierType = carrierType
        }

        switch currCarrierType {
        case CTRadioAccessTechnologyGPRS:
            return "2G" + " (GPRS)"

        case CTRadioAccessTechnologyEdge:
            return "2G" + " (Edge)"

        case CTRadioAccessTechnologyCDMA1x:
            return "2G" + " (CDMA1x)"

        case CTRadioAccessTechnologyWCDMA:
            return "3G" + " (WCDMA)"

        case CTRadioAccessTechnologyHSDPA:
            return "3G" + " (HSDPA)"

        case CTRadioAccessTechnologyHSUPA:
            return "3G" + " (HSUPA)"

        case CTRadioAccessTechnologyCDMAEVDORev0:
            return "3G" + " (CDMAEVDORev0)"

        case CTRadioAccessTechnologyCDMAEVDORevA:
            return "3G" + " (CDMAEVDORevA)"

        case CTRadioAccessTechnologyCDMAEVDORevB:
            return "3G" + " (CDMAEVDORevB)"

        case CTRadioAccessTechnologyeHRPD:
            return "3G" + " (eHRPD)"

        case CTRadioAccessTechnologyLTE:
            return "4G" + " (LTE)"

        default:
            break;
        }

        return "newer type!"
    }
    */

}
