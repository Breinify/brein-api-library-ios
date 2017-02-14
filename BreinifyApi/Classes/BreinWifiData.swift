//
// Created by Marco on 14.02.17.
//

import Foundation


extension CWPHYMode: CustomStringConvertible {
    public var description: String {
        switch(self) {
        case .Mode11a:  return "802.11a";
        case .Mode11ac: return "802.11ac";
        case .Mode11b:  return "802.11b";
        case .Mode11g:  return "802.11g";
        case .Mode11n:  return "802.11n";
        case .ModeNone: return "none";
        }
    }
}

extension CWInterfaceMode: CustomStringConvertible {
    public var description: String {
        switch(self) {
        case .HostAP:  return "AP";
        case .IBSS:    return "Adhoc";
        case .Station: return "Station";
        case .None:    return "none";
        }
    }
}

extension CWSecurity: CustomStringConvertible {
    public var description: String {
        switch(self) {
        case None:               return "none";
        case WEP:                return "WEP";
        case WPAPersonal:        return "WPA Personal";
        case WPAPersonalMixed:   return "WPA Personal Mixed";
        case WPA2Personal:       return "WPA2 Personal";
        case Personal:           return "Personal";
        case DynamicWEP:         return "Dynamic WEP";
        case WPAEnterprise:      return "WPA Enterprise";
        case WPAEnterpriseMixed: return "WPA Enterprise Mixed";
        case WPA2Enterprise:     return "WPA2 Enterprise";
        case Enterprise:         return "Enterprise";
        case Unknown:            return "unknown";
        }
    }
    static let values = [None, WEP, WPAPersonal, WPAPersonalMixed, WPA2Personal, Personal, DynamicWEP, WPAEnterprise, WPAEnterpriseMixed, WPA2Enterprise, Enterprise, Unknown]
}

extension CWChannelBand: CustomStringConvertible {
    public var description: String {
        switch(self) {
        case .Band2GHz: return "2 GHz";
        case .Band5GHz: return "5 Ghz";
        case .BandUnknown: return "unknown";
        }
    }
}

extension CWChannelWidth: CustomStringConvertible {
    public var description: String {
        switch(self) {
        case .Width20MHz:   return "20 MHz";
        case .Width40MHz:   return "40 MHz";
        case .Width80MHz:   return "80 MHz";
        case .Width160MHz:  return "160 MHz";
        case .WidthUnknown: return "unknown";
        }
    }
}

extension CWChannel {
    override public var description: String {
        return "\(channelNumber) (\(channelBand), \(channelWidth))"
    }
}

extension CWNetwork {
    var supportedSecurity: Set<CWSecurity> {
        var supported = Set<CWSecurity>()
        for security in CWSecurity.values {
            if supportsSecurity(security) {
                supported.insert(security)
            }
        }
        return supported
    }

    override public var description: String {
        var str = ""
        if let name = ssid {
            str += "\(name): "
        } else {
            str += "<no ssid>: "
        }
        str += "channel=\(wlanChannel), rssi=\(rssiValue), security=\(supportedSecurity), ibss=\(ibss)"
        if let b = bssid {
            str += ", bssid=\(b)"
        }
        return str
    }
}

extension CWInterface {
    override public var description: String {
        var str = "interface: \(interfaceName!)\n"
        if let ssid = ssid() {
            str += "  ssid: \(ssid)\n"
        }
        if let bssid = bssid() {
            str += "  bssid: \(bssid)\n"
        }
        str += "  active PHY mode: \(activePHYMode())\n"
        str += "  active: \(serviceActive())\n"
        str += "  mode: \(interfaceMode())\n"
        if let channel = wlanChannel() {
            str += "  channel: \(channel)\n"
        }
        str += "  security: \(security())\n"
        if let hardwareAddress = hardwareAddress() {
            str += "  mac address: \(hardwareAddress)\n"
        }
        if let countryCode = countryCode() {
            str += "  country code: \(countryCode)\n"
        }
        str += "  transmit rate: \(transmitRate()) Mbps\n"
        if transmitPower() != 0 { // 0 == error
            str += "  power: \(transmitPower()) mW\n"
        }
        str += "  signal strength (rssi): \(rssiValue()) dBm\n"
        str += "  noise: \(noiseMeasurement()) dBm\n"
        str += "  cached networks:\n"
        if let scanResults = cachedScanResults() {
            for scanResult in scanResults {
                str += "    \(scanResult)\n"
            }
        }

        // there's also interface.configuration(), but not sure if there's anything useful there

        return str
    }
}

class WiFiInfo: CustomStringConvertible {
    var interfaces: Set<CWInterface>
    var description: String {
        return interfaces.description
    }

    init() {
        self.interfaces = Set()
        if let interfaceNames = CWInterface.interfaceNames() {
            for interfaceName in interfaceNames {
                interfaces.insert(CWInterface(name: interfaceName))
            }
        }
    }
}