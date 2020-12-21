//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation
import Alamofire

open class BreinIpInfo {

    /// some constants
    static let kIpField = "query"
    static let kTimezoneField = "timezone"

    /// contains the read data
    var readDataMap: NSDictionary?

    private init() {
    }

    /// singleton
    public static let shared: BreinIpInfo = {
        let instance = BreinIpInfo()

        instance.refreshData()
        return instance
    }()

    /// async call to retrieve the data
    public func refreshData() -> Void {
       invokeRequest()
    }

    /// invokes the http request to retrieve the ipAddress
    public func invokeRequest() -> Void {
        // service url provides external ipAddress
        let url = "http://www.ip-api.com/json"
        Alamofire.request(url)
            .responseJSON {
                response in
                // print(response.request)  // original URL request
                // print(response.response) // URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                // print(response.result.value)
                // http status
                let status = response.response?.statusCode
                if status == 200 {
                    switch response.result {
                    case let .success(value):
                        dump(value)
                        self.readDataMap = value as? NSDictionary
                    case let .failure(error):
                        dump(error)
                    }
                }
        }
    }

    /// provides external ipAddress
    public func getExternalIp() -> String? {
        if let map = self.readDataMap {
            return map.object(forKey: BreinIpInfo.kIpField) as? String
        }
      return ""
    }
}
