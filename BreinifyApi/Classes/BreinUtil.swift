//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation
import IDZSwiftCommonCrypto

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
}
