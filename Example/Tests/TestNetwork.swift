//
//  TestLogger.swift
//  BreinifyApi
//
//  Created by Marco on 22.03.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import XCTest
import BreinifyApi
import SystemConfiguration.CaptiveNetwork


class TestNetwork: XCTestCase {

    func testNetworkInfo() {
         print("WifiSSID is: \(getWiFiSsid())")
    }


    // retrieves the Wifi-String
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }


    func detectFlightMode() {
        
    }
    

}
