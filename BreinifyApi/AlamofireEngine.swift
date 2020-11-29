//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation
import Alamofire

public class AlamofireEngine: IRestEngine {

    /// some handy aliases
    public typealias apiSuccess = (_ result: BreinResult) -> Void
    public typealias apiFailure = (_ error: NSDictionary) -> Void

    // contains a copy of the missedRequests from BreinRequestManager
    var missedRequests: [String: JsonRequest]?

    let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15

        return Session(configuration: configuration)
    }()

    /**
        Configures the rest engine
     
        - parameter breinConfig: configuration object
        
     */
    public func configure(_ breinConfig: BreinConfig) {
    }

    public func executeSavedRequests() {

        BreinLogger.shared.log("executeSavedRequests invoked")

        // 1. loop over entries
        missedRequests = BreinRequestManager.shared.getMissedRequests()

        BreinLogger.shared.log("Number of elements in queue is: \(missedRequests?.count ?? -1)")

        for (uuid, entry) in (missedRequests)! {

            BreinLogger.shared.log("Working on UUID: \(uuid)")

            // 1. is this entry in time range?
            let considerEntry = BreinRequestManager.shared.checkIfValid(currentEntry: entry)
            if considerEntry == true {

                let urlString = entry.fullUrl
                let jsonData = entry.jsonBody

                // 2. send it
                var request = URLRequest(url: URL(string: urlString!)!)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

                // add the uuid to identify the request on response
                request.setValue(uuid, forHTTPHeaderField: "uuid")
                request.httpBody = jsonData?.data(using: .utf8, allowLossyConversion: false)!

                AF.request(request).responseJSON {
                    (response) in

                    // dump(response)

                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)

                    let uuidEntry = response.request?.allHTTPHeaderFields!["uuid"]
                    let status = response.response?.statusCode
                    if status == 200 {
                        BreinRequestManager.shared.removeEntry(uuidEntry!)
                    } else {
                        BreinLogger.shared.log("could not send request with uuid: \(uuidEntry ?? "Nothing")")
                    }
                }

            } else {
                BreinLogger.shared.log("Removing from Queue: \(uuid)")
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

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            BreinLogger.shared.log("jsonString is: \(jsonString)")
        }

        // Alamofire.request(url, method: .post,
        session.request(url, method: .post,
                        parameters: body,
                        encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)

                    // let resp = response.response
                    // let data = response.data
                    // let result = response.result
                    // let httpStatusCode = response.response?.statusCode

//                    let status = response.response?.statusCode
                    // print("HTTP-Status: \(status)")

                    switch response.result {
                    case let .success(value):
                        if success != nil {
                            print(value)
                            let jsonDic: NSDictionary = ["success": 200]
                            let breinResult = BreinResult(dictResult: jsonDic)
                            success(breinResult)
                        }
                    case let .failure(error):
                        if failure != nil {
                            print(error)
                            // add for resending later...
                            let jsonRequest = String(data: (response.request?.httpBody)!,
                                    encoding: .utf8)
                            let urlRequest = response.request?.url?.absoluteString
                            let creationTime = Int(NSDate().timeIntervalSince1970)

                            // add to BreinRequestManager in case of an error
                            BreinRequestManager.shared.addRequest(timeStamp: creationTime,
                                    fullUrl: urlRequest, json: jsonRequest)

                            let httpError: NSError = error as NSError
                            let statusCode = httpError.code
                            let error: NSDictionary = ["error": httpError,
                                                       "statusCode": statusCode]
                            failure(error)
                        }
                    }

                }


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

        do {
            let jsonData = try! JSONSerialization.data(withJSONObject: body as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            _ = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String

            // print(jsonString)
        }

        AF.request(url, method: .post,
                        parameters: body,
                        encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)

                    // http status

                    let status = response.response?.statusCode
                    switch response.result {
                    case let .success(value):
                        let jsonDic = value as! NSDictionary
                        // dump(jsonDic)

                        _ = BreinResult(dictResult: jsonDic)
                        print(value)
                    case let .failure(error):
                        let failError: NSDictionary = ["error": "httpError",
                                                       "statusCode": status!]
                        print(error)
                        print(failError)
                    }
                }
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

        AF.request(url, method: .post,
                        parameters: body,
                        encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)

//                        let status = response.response?.statusCode

                    switch response.result {
                    case let .success(value):
                        print(value)
                        let jsonDic = value as! NSDictionary
                        let breinResult = BreinResult(dictResult: jsonDic)
                        success(breinResult)
                    case let .failure(error):
                        print(error)
                        let httpError: NSError = error as NSError
                        let statusCode = httpError.code
                        let error: NSDictionary = ["error": httpError,
                                                   "statusCode": statusCode]
                        failure(error)
                    }

                }
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

        do {
            // dump(body)
            let jsonData = try! JSONSerialization.data(withJSONObject: body as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            _ = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String

            // print(jsonString)
        }

        // Alamofire.request(url, method: .post,
        session.request(url, method: .post,
                        parameters: body,
                        encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)
                    // dump(response)

//                        let status = response.response?.statusCode

                    switch response.result {
                    case let .success(value):
                        print(value)
                        let jsonDic = value as! NSDictionary
                        let breinResult = BreinResult(dictResult: jsonDic)
                        successBlock(breinResult)
                    case let .failure(error):
                        print(error)
                        let httpError: NSError = error as NSError
                        let statusCode = httpError.code
                        let error: NSDictionary = ["error": httpError,
                                                   "statusCode": statusCode]
                        failureBlock(error)
                    }
                }
    }

    /// This method can be used in the future
    func executeRequest(url: String,
                        body: [String: Any],
                        success successBlock: @escaping apiSuccess,
                        failure failureBlock: @escaping apiFailure) {

        AF.request(url, method: .post,
                        parameters: body,
                        encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)

                    // http status
                    let status = response.response?.statusCode

                    switch response.result {
                    case let .success(value):
                        print(value)
                        let jsonDic = value as! NSDictionary
                        // dump(jsonDic)

                        let breinResult = BreinResult(dictResult: jsonDic)
                        successBlock(breinResult)
                    case let .failure(error):
                        print(error)
                        let error: NSDictionary = ["error": "httpError",
                                                   "statusCode": status!]
                        failureBlock(error)
                    }
                }
    }

    /// Terminates whatever would need to be stopped
    public func terminate() {
    }
}

/*
extension DataRequest {

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONWithId(
            queue: DispatchQueue? = nil,
            options: JSONSerialization.ReadingOptions = .allowFragments,
            completionHandler: @escaping (AFDataResponse<Any>) -> Void)
                    -> Self {
        response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(options: options),
                completionHandler: completionHandler
        )
    }
}
*/
