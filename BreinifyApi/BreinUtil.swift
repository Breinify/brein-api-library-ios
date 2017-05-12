//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto
import NetUtils


public class BreinUtil {

    /**
       generate the signature

       - parameter: message contains the message that needs to be encrypted
       - parameter: secret contains the secret

       - returns: encrypted message based on HMac256 algorithmn
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
        return true;
    }

    static public func containsValue(_ value: String?) -> String? {
        if value == nil {
            return nil
        }

        if value?.characters.count == 0 {
            return nil
        }

        return value
    }
    
    static public func detectIpAddress() -> String {

        let interfaces = Interface.allInterfaces()

        // only en0, running & up
        for i in interfaces {
            if i.isRunning && i.isUp {
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
    }


    static public func getDoubleValue(_ value: Any) -> Double {
        
        if let doubleValue = value as? Double {
            return doubleValue
        }

        if let stringValue = value as? String {
            // convert to Double
            let convertedDoubleValue = Double(stringValue ?? "") ?? 0.0
            return convertedDoubleValue
        }

        return 0.0
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
        return Formatter.iso8601.string(from: self)
    }
    var breinifyFormat: String {
        return Formatter.breinifyFormat.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
