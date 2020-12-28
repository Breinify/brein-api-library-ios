//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinIpInfo {

    /// some constants
    static let kIpField = "query"
    static let kTimezoneField = "timezone"

    /// contains the read data
    var readDataMap: [String: Any]?

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

        // todo
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                // success

                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    BreinLogger.shared.log("IP detection response:\n \(dataString)")
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let myDictionary = dictionary {
                            self.readDataMap = myDictionary
                        }
                    } catch let error as NSError {
                        BreinLogger.shared.log("IP detection with error: \(error)")
                    }
                }
            }
        }
        task.resume()

//        Alamofire.request(url)
//            .responseJSON {
//                response in
//                // print(response.request)  // original URL request
//                // print(response.response) // URL response
//                // print(response.data)     // server data
//                // print(response.result)   // result of response serialization
//                // print(response.result.value)
//                // http status
//                let status = response.response?.statusCode
//                if status == 200 {
//                    switch response.result {
//                    case let .success(value):
//                        dump(value)
//                        self.readDataMap = value as? NSDictionary
//                    case let .failure(error):
//                        dump(error)
//                    }
//                }
//        }
    }

    /// provides external ipAddress
    public func getExternalIp() -> String? {
        if let map = self.readDataMap {
            if let ip = self.readDataMap?[BreinIpInfo.kIpField] as? String {
                return ip
            }
            return ""
        }
        return ""
    }

    /// provides timezone
    public func getTimezone() -> String? {
        if let map = self.readDataMap {
            if let timeZone = self.readDataMap?[BreinIpInfo.kTimezoneField] as? String {
                return timeZone
            }
            return ""
        }
        return ""
    }
}
