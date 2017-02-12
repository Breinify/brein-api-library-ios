//
// Created by Marco on 27.07.16.
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto

extension String {

    // TODO: check if twice

    // pre-defined constants for Category
    static let APPAREL = "apparel"
    static let HOME = "home"
    static let EDUCATION = "education"
    static let FAMILY = "family"
    static let FOOD = "food"
    static let HEALTH = "health"
    static let JOB = "job"
    static let SERVICES = "services"
    static let OTHER = "other"

    // pre-defined constants for ActivityType
    static let SEARCH = "search"
    static let LOGIN = "login"
    static let LOGOUT = "logout"
    static let ADD_TO_CART = "addToCart"
    static let REMOVE_FROM_CART = "removeFromCart"
    static let SELECT_PRODUCT = "selectProduct"
    static let CHECKOUT = "checkOut"

    // used for the signature
    func digestHMac256(key: String) -> String! {
        
        let message = self
        let hmac256 = HMAC(algorithm: .SHA256, key: key).update(message)?.final()
        
        if let hmac = hmac256 {
            
            //Convert [UInt8] to NSData
            let data = NSData(bytes: hmac, length: hmac.count)
            
            //Encode to base64
            let base64Data = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            
            return base64Data
        }
        
        return ""
    }

}