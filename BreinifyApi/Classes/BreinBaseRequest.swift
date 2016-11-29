//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinBaseRequest {

    /**
    * contains an extra map for the base section
    */
    var baseMap: [String: AnyObject]?

    init() {
    }

    /**
    * sets an extra map for the base section
    *
    * @param extraBaseMap map of <String, Object></String,>
    */
    public func setUserMap(extraBaseMap: [String: AnyObject]!) {
        self.baseMap = extraBaseMap
    }

    /**
    * returns the extra map for the base section
    *
    * @return map <String, Object>
    */
    public func getUserMap() -> [String: AnyObject]! {
        return baseMap
    }

    /**
    * prepares the request for the base section with standard fields
    * plus possible extra fields if configured
    *
    * @param breinBase   contains the appropriate request object
    * @param requestData contains the created json structure
    * @param isSign      indicates if the request must be signed (secret option)
    */
    public func prepareBaseRequestData(breinBase: BreinBase,
                                       inout requestData: [String: AnyObject],
                                       isSign: Bool) {

        if let apiKey = breinBase.getConfig()?.getApiKey() where !apiKey.isEmpty {
            requestData["apiKey"] = apiKey
        }

        requestData["unixTimestamp"] = breinBase.getUnixTimestamp()

        if let ipAddress = breinBase.getBreinUser().getIpAddress() {
            requestData["ipAddress"] = ipAddress
        }

        // if sign is active
        if isSign == true {
            requestData["signature"] = breinBase.createSignature()
            requestData["signatureType"] = "HmacSHA256"
        }

        // check if there are further extra maps to add on base level
        if let bMap = baseMap {
            if bMap.count > 0 {
                BreinMapUtil.fillMap(bMap, requestStructure: &requestData)
            }
        }
    }
}