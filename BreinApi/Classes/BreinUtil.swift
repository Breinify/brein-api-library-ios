//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation
import IDZSwiftCommonCrypto

class BreinUtil {


    static func generateSignature(message: String!, secret: String!) throws -> String {

        if message == nil || secret == nil {
            throw BreinError.BreinRuntimeError("Illegal value for message or secret in method generateSignature")
        }

       return message.digestHMac256(secret)
    }

    static func isUrlValid(url: String!) -> Bool {
        return true;

    }

}
