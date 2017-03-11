//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation
import Alamofire

public class AlamofireEngine: IRestEngine {

    /// some handy aliases
    public typealias apiSuccess = (_ result: BreinResult?) -> Void
    public typealias apiFailure = (_ error: NSDictionary?) -> Void

    /**
     configures the rest engine

     - parameter breinConfig: configuration object
    */
    public func configure(_ breinConfig: BreinConfig) {
    }

    /**
      Invokes the post request for activities

      - parameter breinActivity: activity object
      - parameter success successBlock: will be invoked in case of success
      - parameter failure failureBlock: will be invoked in case of an error
    */
    public func doRequest(_ breinActivity: BreinActivity,
                          success successBlock: @escaping apiSuccess,
                          failure failureBlock: @escaping apiFailure) throws {

        try validate(breinActivity)

        let url = try getFullyQualifiedUrl(breinActivity)
        let body = try getRequestBody(breinActivity)


        do {
            let jsonData = try! JSONSerialization.data(withJSONObject: body as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String

            print(jsonString)
        } 

        /*
        let configuration = URLSessionConfiguration.background(withIdentifier: url)
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.request(.POST,....

        return SessionManager.default.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )




        */

        Alamofire.request(url, method: .post,
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

                    if response.result.isSuccess {
                        let jsonDic: NSDictionary = ["success": 200]
                        let breinResult = BreinResult(dictResponse: jsonDic)
                        successBlock(breinResult)

                    } else {
                        let httpError: NSError = response.result.error! as NSError
                        let statusCode = httpError.code
                        let error: NSDictionary = ["error": httpError,
                                                   "statusCode": statusCode]
                        failureBlock(error)
                    }
                }
    }
    
    /**
       Invokes the post request for recommendations

       - parameter breinRecommendation: recommendation object
       - parameter success successBlock: will be invoked in case of success
       - parameter failure failureBlock: will be invoked in case of an error
     */
    public func doRecommendation(_ breinRecommendation: BreinRecommendation,
                                 success successBlock: @escaping (_ result: BreinResult?) -> Void,
                                 failure failureBlock: @escaping (_ error: NSDictionary?) -> Void) throws {

        try validate(breinRecommendation)

        let url = try getFullyQualifiedUrl(breinRecommendation)
        let body = try getRequestBody(breinRecommendation)

        /*
        do {
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String

            dump(jsonString)
        } catch let error as NSError {
            dump(error)
        }
        */

        Alamofire.request(url, method: .post,
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

                    // if response.result.isSuccess {
                    if status == 200 {
                        let jsonDic = response.result.value as! NSDictionary
                        // dump(jsonDic)

                        let breinResult = BreinResult(dictResponse: jsonDic)
                        successBlock(breinResult)
                    } else {
                        /*
                        let httpError: NSError = response.result.error!
                        let statusCode = httpError.code
                        */
                        let error: NSDictionary = ["error": "httpError",
                                                   "statusCode": status!]
                        failureBlock(error)
                    }
                }
    }

    /**
       Invokes the post request for lookups

       - parameter breinLookup: lookup object
       - parameter success successBlock: will be invoked in case of success
       - parameter failure failureBlock: will be invoked in case of an error
     */
    public func doLookup(_ breinLookup: BreinLookup,
                         success successBlock: @escaping apiSuccess,
                         failure failureBlock: @escaping apiFailure) throws {

        try validate(breinLookup)

        let url = try getFullyQualifiedUrl(breinLookup)
        let body = try getRequestBody(breinLookup)

        /*
        do {
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String

            dump(jsonString)
        } catch let error as NSError {
            dump(error)
        }
        */

        Alamofire.request(url, method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)

                    if response.result.isSuccess {
                        let jsonDic = response.result.value as! NSDictionary
                        let breinResult = BreinResult(dictResponse: jsonDic)
                        successBlock(breinResult)

                    } else {
                        let httpError: NSError = response.result.error! as NSError
                        let statusCode = httpError.code
                        let error: NSDictionary = ["error": httpError,
                                                   "statusCode": statusCode]
                        failureBlock(error)
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

        /*
        do {
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String

            dump(jsonString)
        } catch let error as NSError {
            dump(error)
        }
        */

        Alamofire.request(url, method: .post,
                        parameters: body,
                        encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    // print(response.result.value)

                    if response.result.isSuccess {
                        let jsonDic = response.result.value as! NSDictionary
                        let breinResult = BreinResult(dictResponse: jsonDic)
                        successBlock(breinResult)

                    } else {
                        let httpError: NSError = response.result.error! as NSError
                        let statusCode = httpError.code
                        let error: NSDictionary = ["error": httpError,
                                                   "statusCode": statusCode]
                        failureBlock(error)
                    }
                }
    }

    /// This method can be used in the future
    func executeRequest(url: String,
                        body: [String: AnyObject],
                        success successBlock: @escaping apiSuccess,
                        failure failureBlock: @escaping apiFailure) {

        Alamofire.request(url, method: .post,
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

                    // if response.result.isSuccess {
                    if status == 200 {
                        let jsonDic = response.result.value as! NSDictionary
                        // dump(jsonDic)

                        let breinResult = BreinResult(dictResponse: jsonDic)
                        successBlock(breinResult)
                    } else {
                        /*
                        let httpError: NSError = response.result.error!
                        let statusCode = httpError.code
                        */
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
