//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto
import NetUtils

public class BreinUtil {

    /**
       generate the signature

       - parameter: message contains the message that needs to be encrypted
       - parameter: secret contains the secret

       - returns: encrypted message based on HMac256 algorithm
    */
    static public func generateSignature(_ message: String!, secret: String!) throws -> String {

        if message == nil || secret == nil {
            throw BreinError.BreinRuntimeError("Illegal value for message or secret in method generateSignature")
        }
        return message.digestHMac256(secret)
    }

    // should check if an url is valid
    // for the time being we assume that this is the case
    static public func isUrlValid(_ url: String!) -> Bool {
        // todo check missing
        true;
    }

    static public func containsValue(_ value: String?) -> String? {
        if value == nil {
            return nil
        }

        if value?.count == 0 {
            return nil
        }

        return value
    }

    static public func detectIpAddress() -> String {
        BreinIpInfo.shared.getExternalIp()!

        // only en0, running & up
        /* this will only provide the local Ip
         let interfaces = Interface.allInterfaces()
         
         for i in interfaces {
            if i.isRunning && i.isUp {
                print("Adr is: \(i.address)")
                if i.name.lowercased() == "en0" {
                    if i.family.toString().lowercased() == "ipv4" {
                        if let ip = i.address {
                            // print("Address: \(ip)")
                            return ip
                        }
                    }
                }
            }
        }
        return ""
        */
    }

    static public func getDoubleValue(_ value: Any?) -> Double? {

        if let doubleValue = value as? Double {
            return doubleValue
        }

        if let stringValue = value as? String {
            // convert to Double
            let convertedDoubleValue = Double(stringValue) ?? 0.0
            return convertedDoubleValue
        }

        return nil
    }

    static public func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
        let start = CACurrentMediaTime()
        block()
        let end = CACurrentMediaTime()
        return end - start
    }

    static public func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()

    static let breinifyFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        // formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss ZZZZ (zz)"
        return formatter
    }()

}

extension Date {
    var iso8601: String {
        Formatter.iso8601.string(from: self)
    }
    var breinifyFormat: String {
        Formatter.breinifyFormat.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        Formatter.iso8601.date(from: self)
    }
}
