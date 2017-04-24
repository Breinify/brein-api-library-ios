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

    public typealias apiSuccess = (_ result: BreinResult) -> Void
    public typealias apiFailure = (_ error: NSDictionary) -> Void

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

       Important:
       * due to the fact that the locationManager will invoke CLLocationManager it must run on the
         main thread 

     */
    public func sendActivity(_ activity: BreinActivity!,
                             success successBlock: @escaping BreinEngine.apiSuccess,
                             failure failureBlock: @escaping BreinEngine.apiFailure) throws {
        
        if activity != nil {
            // necessary to invoke CLLocationManager
            // need to come back to main thread
            DispatchQueue.main.async {
                
                self.locationManager.fetchWithCompletion {

                    location, error in

                    // save the retrieved location data
                    activity.getUser()?.setLocationData(location)

                    // print("latitude is: \(location?.coordinate.latitude)")
                    // print("longitude is: \(location?.coordinate.longitude)")

                    do {
                        try self.restEngine.doRequest(activity,
                                success: successBlock,
                                failure: failureBlock)
                    } catch {
                        // TODO throw error
                        print("\(error)")
                    }
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
    public func performTemporalDataRequest(_ breinTemporalData: BreinTemporalData!,
                                           success successBlock: @escaping apiSuccess,
                                           failure failureBlock: @escaping apiFailure) throws {
        if breinTemporalData != nil {

            // necessary to invoke CLLocationManager
            // need to come back to main thread
            DispatchQueue.main.async {

                self.locationManager.fetchWithCompletion {

                    location, error in

                    // save the retrieved location data
                    breinTemporalData.getUser()?.setLocationData(location)

                    print("latitude is: \(location?.coordinate.latitude)")
                    print("longitude is: \(location?.coordinate.longitude)")

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
    }

    /**
     Performs a lookup. This will be delegated to the configured restEngine.

       - parameter breinLookup: contains the appropriate data for the lookup request
       - Parameter successBlock : A callback function that is invoked in case of success.
       - Parameter failureBlock : A callback function that is invoked in case of an error.
     
       - returns:  if succeeded a BreinResponse object or  null
    */
    public func performLookUp(_ breinLookup: BreinLookup!,
                              success successBlock: @escaping apiSuccess,
                              failure failureBlock: @escaping apiFailure) throws {

        if breinLookup != nil {

            // necessary to invoke CLLocationManager
            // need to come back to main thread
            DispatchQueue.main.async {

                self.locationManager.fetchWithCompletion {

                    location, error in

                    // save the retrieved location data
                    breinLookup.getUser()?.setLocationData(location)

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
    }

    /**
     Invokes the recommendation request

      - parameter breinRecommendation: contains the breinRecommendation object
      - Parameter successBlock : A callback function that is invoked in case of success.
      - Parameter failureBlock : A callback function that is invoked in case of an error.

      - return result of request or null
    */
    public func invokeRecommendation(_ breinRecommendation: BreinRecommendation!,
                                     success successBlock: @escaping BreinEngine.apiSuccess,
                                     failure failureBlock: @escaping BreinEngine.apiFailure) throws {


        if breinRecommendation != nil {

            // necessary to invoke CLLocationManager
            // need to come back to main thread
            DispatchQueue.main.async {

                self.locationManager.fetchWithCompletion {

                    location, error in

                    // save the retrieved location data
                    breinRecommendation.getUser()?.setLocationData(location)

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
    }
    
    /**
     Returns the rest engine

     - returns: engine itself
    */
    public func getRestEngine() -> IRestEngine! {
        return restEngine
    }

    /**
     Configuration of engine

     - parameter breinConfig: configuration object

     */
    public func configure(_ breinConfig: BreinConfig!) {
        restEngine.configure(breinConfig)
    }

}
