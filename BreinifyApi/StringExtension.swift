//
// Created by Marco on 27.07.16.
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto

extension String {
    // pre-defined constants for Category
    public static let apparel = "apparel"
    public static let home = "home"
    public static let education = "education"
    public static let family = "family"
    public static let food = "food"
    public static let health = "health"
    public static let job = "job"
    public static let services = "services"
    public static let other = "other"

    // pre-defined constants for ActivityType
    public static let search = "search"
    public static let login = "login"
    public static let logout = "logout"
    public static let addToCart = "addToCart"
    public static let removeFromCart = "removeFromCart"
    public static let selectProduct = "selectProduct"
    public static let checkout = "checkOut"

    // used for the signature
    func digestHMac256(_ key: String) -> String! {
        let message = self
        let bytes = message.utf16.count
        let hmac256 = HMAC(algorithm: .sha256, key: key).update(buffer: message, byteCount: bytes)?.final()

        if let hmac = hmac256 {
            //Convert [UInt8] to NSData
            let data = NSData(bytes: hmac, length: hmac.count)

            //Encode to base64
            let base64Data = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)

            return base64Data
        }
        return ""
    }

}
