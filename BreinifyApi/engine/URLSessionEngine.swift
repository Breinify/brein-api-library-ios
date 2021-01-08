//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

public class URLSessionEngine: IRestEngine {

    /// some handy aliases
    public typealias apiSuccess = (_ result: BreinResult) -> Void
    public typealias apiFailure = (_ error: NSDictionary) -> Void

    /**
        Configures the rest engine
     
        - parameter breinConfig: configuration object
        
     */
    public func configure(_ breinConfig: BreinConfig) {
    }

    public func executeSavedRequests() {

        BreinLogger.shared.log("Breinify executeSavedRequests invoked")

        // 1. loop over entries
        // contains a copy of the missedRequests from BreinRequestManager
        let missedRequests = BreinRequestManager.shared.getMissedRequests()

        BreinLogger.shared.log("Breinify number of elements in queue is: \(missedRequests.count)")

        for (uuid, entry) in (missedRequests) {
            BreinLogger.shared.log("Working on UUID: \(uuid)")

            // 1. is this entry in time range?
            let considerEntry = BreinRequestManager.shared.checkIfValid(currentEntry: entry)
            if considerEntry == true {

                let urlString = entry.fullUrl
                let jsonData:String = entry.jsonBody

                // 2. send it
                var request = URLRequest(url: URL(string: urlString!)!)
                request.httpMethod = "POST"
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                // add the uuid to identify the request on response
                request.setValue(uuid, forHTTPHeaderField: "uuid")
                request.httpBody = jsonData.data(using: .utf8)

                // replace start
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                        // success
                        if let resp = response as? HTTPURLResponse {
                            let uuidEntryAny = resp.allHeaderFields["uuid"]
                            if let uuidEntry = uuidEntryAny as? String {
                                BreinLogger.shared.log("Breinify successfully (resend): \(String(describing: jsonData))")
                                BreinRequestManager.shared.removeEntry(uuidEntry)
                            }
                        }
                    }
                }
                task.resume()
                // replace end
            } else {
                BreinLogger.shared.log("Breinify removing from queue: \(uuid)")
                BreinRequestManager.shared.removeEntry(uuid)
            }
        }
    }

    /**
     Invokes the post request for activities
     
     - parameter breinActivity: activity object
     - parameter success: will be invoked in case of success
     - parameter failure: will be invoked in case of an error
     */
    public func doRequest(_ breinActivity: BreinActivity,
                          success: @escaping apiSuccess,
                          failure: @escaping apiFailure) throws {

        try validate(breinActivity)

        let url = try getFullyQualifiedUrl(breinActivity)
        let body = try getRequestBody(breinActivity)

        var jsonString = ""
        var jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: body as Any, options: [.prettyPrinted])
            jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let activity:[String: Any] = body?["activity"] as! [String : Any]
            let actTyp:String = activity["type"] as! String

            BreinLogger.shared.log("Breinify doRequest for activityType: \(actTyp) -- json is: \(String(describing: jsonString))")
        }

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData

        // Alamofire.request(url, method: .post,
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                BreinLogger.shared.log("Breinify doRequest with error: \(error)")

                let canResend = breinActivity.getConfig()?.getResendFailedActivities()

                // add for resending later..
                if canResend == true {

                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        BreinLogger.shared.log("Breinify response data string: \(dataString)")

                        let urlRequest = url
                        let creationTime = Int(NSDate().timeIntervalSince1970)

                        // add to BreinRequestManager in case of an error
                        BreinRequestManager.shared.addMissedRequest(timeStamp: creationTime,
                                fullUrl: urlRequest, json: dataString)
                    }
                }
                let httpError: NSError = error as NSError
                let statusCode = httpError.code
                let error: NSDictionary = ["error": httpError,
                                           "statusCode": statusCode]
                DispatchQueue.main.async {
                    failure(error)
                }
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                // success
                let jsonDic: NSDictionary = ["success": 200]
                let breinResult = BreinResult(dictResult: jsonDic)

                DispatchQueue.main.async {
                    success(breinResult)
                }
            }
        }
        task.resume()
    }

    /**
     Invokes the post request for lookups

     - parameter breinLookup: lookup object
     - parameter success success: will be invoked in case of success
     - parameter failure failure: will be invoked in case of an error
     */
    public func doLookup(_ breinLookup: BreinLookup,
                         success: @escaping apiSuccess,
                         failure: @escaping apiFailure) throws {
        try validate(breinLookup)

        let url = try getFullyQualifiedUrl(breinLookup)
        let body = try getRequestBody(breinLookup)

        var jsonString = ""
        var jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: body as Any, options: [.prettyPrinted])
            jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            BreinLogger.shared.log("Breinify doLookup - json is: \(String(describing: jsonString))")
        }

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData

        // Alamofire.request(url, method: .post,
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                BreinLogger.shared.log("Breinify doLookup with error: \(error)")

                let httpError: NSError = error as NSError
                let statusCode = httpError.code
                let error: NSDictionary = ["error": httpError,
                                           "statusCode": statusCode]
                DispatchQueue.main.async {
                    failure(error)
                }
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                // success
                let jsonDic: NSDictionary = ["success": 200]
                let breinResult = BreinResult(dictResult: jsonDic)

                DispatchQueue.main.async {
                    success(breinResult)
                }
            }

        }
        task.resume()
    }

    /**
  Invokes the post request for recommendations

  - parameter breinRecommendation: recommendation object
  - parameter success: will be invoked in case of success
  - parameter failure: will be invoked in case of an error
  */
    public func doRecommendation(_ breinRecommendation: BreinRecommendation,
                                 success: @escaping (_ result: BreinResult) -> Void,
                                 failure: @escaping (_ error: NSDictionary) -> Void) throws {
        try validate(breinRecommendation)
        let url = try getFullyQualifiedUrl(breinRecommendation)
        let body = try getRequestBody(breinRecommendation)

        var jsonData:Data
        do {
            jsonData = try! JSONSerialization.data(withJSONObject: body as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            BreinLogger.shared.log("Breinify doRecommendation - json is: \(String(describing: jsonString))")
        }

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData

        // Alamofire.request(url, method: .post,
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                BreinLogger.shared.log("Breinify doRecommendation with error: \(error)")

                let httpError: NSError = error as NSError
                let statusCode = httpError.code
                let error: NSDictionary = ["error": httpError,
                                           "statusCode": statusCode]
                DispatchQueue.main.async {
                    failure(error)
                }
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                // success
                let jsonDic: NSDictionary = ["success": 200]
                let breinResult = BreinResult(dictResult: jsonDic)

                DispatchQueue.main.async {
                    success(breinResult)
                }
            }
        }
        task.resume()
    }

    /**
     Invokes the post request for temporalData

     - parameter breinTemporalData: temporalData object
     - parameter success successBlock: will be invoked in case of success
     - parameter failure failureBlock: will be invoked in case of an error
     */
    public func doTemporalDataRequest(_ breinTemporalData: BreinTemporalData,
                                      success successBlock: @escaping apiSuccess,
                                      failure failureBlock: @escaping apiFailure) throws {
        try validate(breinTemporalData)

        let url = try getFullyQualifiedUrl(breinTemporalData)
        let body = try getRequestBody(breinTemporalData)

        var jsonData:Data
        do {
            jsonData = try! JSONSerialization.data(withJSONObject: body as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            BreinLogger.shared.log("Breinify doTemporalDataRequest - json is: \(String(describing: jsonString))")
        }

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData

        // Alamofire.request(url, method: .post,
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                BreinLogger.shared.log("Breinify doTemporalDataRequest with error: \(error)")

                let httpError: NSError = error as NSError
                let statusCode = httpError.code
                let error: NSDictionary = ["error": httpError,
                                           "statusCode": statusCode]
                DispatchQueue.main.async {
                    failureBlock(error)
                }
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                // success
                let jsonDic: NSDictionary = ["success": 200]
                let breinResult = BreinResult(dictResult: jsonDic)

                DispatchQueue.main.async {
                    successBlock(breinResult)
                }
            }
        }
        task.resume()
    }

    /// Terminates whatever would need to be stopped
    public func terminate() {
    }
}

