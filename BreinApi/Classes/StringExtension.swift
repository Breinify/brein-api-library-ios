//
// Created by Marco on 27.07.16.
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto

extension String {

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