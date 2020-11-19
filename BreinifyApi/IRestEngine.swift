//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

///
/// Interface for all possible rest engines
///

public protocol IRestEngine {

    /**
      configures the rest engine

      - parameter breinConfig: configuration object
    */
    func configure(_ breinConfig: BreinConfig)

    func executeSavedRequests()
    
    /**
       Invokes the post request for activities

       - parameter breinActivity: activity object
       - parameter success successBlock: will be invoked in case of success
       - parameter failure failureBlock: will be invoked in case of an error
     */
    func doRequest(_ breinActivity: BreinActivity,
                   success successBlock: @escaping (_ result: BreinResult) -> Void,
                   failure failureBlock: @escaping (_ error: NSDictionary) -> Void) throws

    /**
       Invokes the post request for lookups

       - parameter breinLookup: lookup object
       - parameter success: will be invoked in case of success
       - parameter failure: will be invoked in case of an error
     */
    func doLookup(_ breinLookup: BreinLookup,
                  success successBlock: @escaping (_ result: BreinResult) -> Void,
                  failure failureBlock: @escaping (_ error: NSDictionary) -> Void) throws

    /**
       Invokes the post request for recommendations

       - parameter breinRecommendation: recommendation object
       - parameter success: will be invoked in case of success
       - parameter failure: will be invoked in case of an error
     */
    func doRecommendation(_ breinRecommendation: BreinRecommendation,
                          success successBlock: @escaping (_ result: BreinResult) -> Void,
                          failure failureBlock: @escaping (_ error: NSDictionary) -> Void) throws

    /**
       Invokes the post request for temporalData

       - parameter breinTemporalData: temporalData object
       - parameter success: will be invoked in case of success
       - parameter failure: will be invoked in case of an error
     */
    func doTemporalDataRequest(_ breinTemporalData: BreinTemporalData,
                               success successBlock: @escaping (_ result: BreinResult) -> Void,
                               failure failureBlock: @escaping (_ error: NSDictionary) -> Void) throws

    /**
       Terminates the rest engine
    */
    func terminate()
}
