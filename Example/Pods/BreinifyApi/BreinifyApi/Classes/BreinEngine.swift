//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

/**
 Creates the Rest Engine (currently only Alamofire) and provides the methods to
 invoke activity and lookup calls
*/
public class BreinEngine {

    public typealias apiSuccess = (result: BreinResult?) -> Void
    public typealias apiFailure = (error: NSDictionary?) -> Void

    /**
     creation of rest engine - currently it is only Alamofire
     */
    var restEngine: IRestEngine!

    /**
     Contains the instance of the locationManager -> this enables the API to
     detect the location information if the info.plist of the app has the
     permissions.
    */
    var locationManager = BreinLocationManager(ignoreLocationRequest: false)

    /**
     Creates the BreinEngine instance with a given breinEngineType
    */
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
     Sends an activity to the Breinify server
     
       - parameter activity: data to be send
       - Parameter successBlock : A callback function that is invoked in case of success.
       - Parameter failureBlock : A callback function that is invoked in case of an error.
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

    /**
     Performs a temporalData request

       - parameter breinTemporalData: contains the appropriate data in order to perform the request
       - Parameter successBlock : A callback function that is invoked in case of success.
       - Parameter failureBlock : A callback function that is invoked in case of an error.
      
      - returns: result from Breinify engine
    */
    public func performTemporalDataRequest(breinTemporalData: BreinTemporalData!,
                                           success successBlock: apiSuccess,
                                           failure failureBlock: apiFailure) throws {
        if breinTemporalData != nil {

            locationManager.fetchWithCompletion {

                location, error in

                // save the retrieved location data
                breinTemporalData.getBreinUser().setLocationData(location)

                // print("latitude is: \(location?.coordinate.latitude)")
                // print("longitude is: \(location?.coordinate.longitude)")

                do {
                    return try self.restEngine.doTemporalDataRequest(breinTemporalData,
                            success: successBlock,
                            failure: failureBlock)
                } catch {
                    print("performTemporalDataRequest error is: \(error)")
                }
            }
        }
    }

    /**
     Performs a lookup. This will be delegated to the configured restEngine.

       - parameter breinLookup: contains the appropriate data for the lookup request
       - Parameter successBlock : A callback function that is invoked in case of success.
       - Parameter failureBlock : A callback function that is invoked in case of an error.
     
       - returns:  if succeeded a BreinResponse object or  null
    */
    public func performLookUp(breinLookup: BreinLookup!,
                              success successBlock: apiSuccess,
                              failure failureBlock: apiFailure) throws {

        if breinLookup != nil {

            locationManager.fetchWithCompletion {

                location, error in

                // save the retrieved location data
                breinLookup.getBreinUser().setLocationData(location)

                // print("latitude is: \(location?.coordinate.latitude)")
                // print("longitude is: \(location?.coordinate.longitude)")

                do {
                    if breinLookup != nil {
                        return try self.restEngine.doLookup(breinLookup,
                                success: successBlock,
                                failure: failureBlock)
                    }
                } catch {
                    print("performLookUp error is: \(error)")
                }
            }
        }
    }

    /**
     Invokes the recommendation request

      - parameter breinRecommendation: contains the breinRecommendation object
      - Parameter successBlock : A callback function that is invoked in case of success.
      - Parameter failureBlock : A callback function that is invoked in case of an error.

      - return result of request or null
    */
    public func invokeRecommendation(breinRecommendation: BreinRecommendation!,
                                     success successBlock: BreinEngine.apiSuccess,
                                     failure failureBlock: BreinEngine.apiFailure) throws {


        if breinRecommendation != nil {

            locationManager.fetchWithCompletion {

                location, error in

                // save the retrieved location data
                breinRecommendation.getBreinUser().setLocationData(location)

                // print("latitude is: \(location?.coordinate.latitude)")
                // print("longitude is: \(location?.coordinate.longitude)")

                do {
                    if breinRecommendation != nil {
                        return try self.restEngine.doRecommendation(breinRecommendation,
                                success: successBlock,
                                failure: failureBlock)
                    }
                } catch {
                    print("invokeRecommendation error is: \(error)")
                }
            }
        }
    }

    /**
     Returns the rest engine

     - return engine itself
    */
    public func getRestEngine() -> IRestEngine! {
        return restEngine
    }

    /**
     Configuration of engine

     -parameter breinConfig: configuration object

     */
    public func configure(breinConfig: BreinConfig!) {
        restEngine.configure(breinConfig)
    }

}
