//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation
import Alamofire


//

public class AlamofireEngine: IRestEngine {

    public typealias apiSuccess = (result:BreinResult?) -> Void
    public typealias apiFailure = (error:NSDictionary?) -> Void

    public func configure(breinConfig: BreinConfig) {
    }

    public func doRequest(breinActivity: BreinActivity,
                          success successBlock: apiSuccess,
                          failure failureBlock: apiFailure) throws {

        try validate(breinActivity)

        let url = try getFullyQualifiedUrl(breinActivity)
        let body = try getRequestBody(breinActivity)

        Alamofire.request(.POST,
                url,
                parameters: body,
                encoding: .JSON)
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
                successBlock(result: breinResult)

            } else {
                let httpError: NSError = response.result.error!
                let statusCode = httpError.code
                let error: NSDictionary = ["error": httpError,
                                           "statusCode": statusCode]
                failureBlock(error: error)
            }
        }
    }

    public func doLookup(breinLookup: BreinLookup,
                         success successBlock: apiSuccess,
                         failure failureBlock: apiFailure) throws {

        try validate(breinLookup)

        let url = try getFullyQualifiedUrl(breinLookup)
        let body = try getRequestBody(breinLookup)

        Alamofire.request(.POST,
                url,
                parameters: body,
                encoding: .JSON)
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
                successBlock(result: breinResult)

            } else {
                let httpError: NSError = response.result.error!
                let statusCode = httpError.code
                let error: NSDictionary = ["error": httpError,
                                           "statusCode": statusCode]
                failureBlock(error: error)
            }
        }
    }

    public func terminate() {
    }
}