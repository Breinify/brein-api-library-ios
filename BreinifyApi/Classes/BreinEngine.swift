//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinEngine {

    public typealias apiSuccess = (result: BreinResult?) -> Void
    public typealias apiFailure = (error: NSDictionary?) -> Void

    var restEngine: IRestEngine!

    var locationManager = BreinLocationManager(ignoreLocationRequest: false)
    
    public init(engineType: BreinEngineType) {

        self.restEngine = AlamofireEngine()

        /*

        switch engineType {
        case BreinEngineType.ALAMOFIRE:
            self.restEngine = AlamofireEngine()
        }
        */
    }

    /**
     * sends an activity to the Breinify server
     *
     * @param activity data
     */
    public func sendActivity(activity: BreinActivity!,
                             success successBlock: BreinEngine.apiSuccess,
                             failure failureBlock: BreinEngine.apiFailure) throws {
        if activity != nil {

            locationManager.fetchWithCompletion {

                location, error in

                // save the retrieved location data
                activity.getBreinUser().setLocationData(location)

                // print("latitude is: \(location?.coordinate.latitude)")
                // print("longitude is: \(location?.coordinate.longitude)")

                do {
                    try self.restEngine.doRequest(activity,
                            success: successBlock,
                            failure: failureBlock)
                } catch {
                    print("\(error)")
                }
            }
        }
    }

    public func performTemporalDataRequest(breinTemporalData: BreinTemporalData!,
                                           success successBlock: apiSuccess,
                                           failure failureBlock: apiFailure) throws {
        if breinTemporalData != nil {
            return try restEngine.doTemporalDataRequest(breinTemporalData,
                    success: successBlock,
                    failure: failureBlock)
        }
    }

    public func performLookUp(breinLookup: BreinLookup!,
                              success successBlock: apiSuccess,
                              failure failureBlock: apiFailure) throws {
        if breinLookup != nil {
            return try restEngine.doLookup(breinLookup,
                    success: successBlock,
                    failure: failureBlock)
        }
    }

    public func invokeRecommendation(breinRecommendation: BreinRecommendation!,
                                     success successBlock: BreinEngine.apiSuccess,
                                     failure failureBlock: BreinEngine.apiFailure) throws {

        if breinRecommendation != nil {
            return try restEngine.doRecommendation(breinRecommendation,
                    success: successBlock,
                    failure: failureBlock)
        }
    }

    public func getRestEngine() -> IRestEngine! {
        return restEngine
    }

    public func configure(breinConfig: BreinConfig!) {
        restEngine.configure(breinConfig)
    }
    
}
