//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

///
/// Interface for all possible rest  engines
///

public protocol IRestEngine {

    /**
      configures the rest engine

      - parameter breinConfig: configuration object
    */
    func configure(breinConfig: BreinConfig)

    /**
       Invokes the post request for activities

       - parameter breinActivity: activity object
       - parameter success successBlock: will be invoked in case of success
       - parameter failure failureBlock: will be invoked in case of an error
     */
    func doRequest(breinActivity: BreinActivity,
                   success successBlock: (result: BreinResult?) -> Void,
                   failure failureBlock: (error: NSDictionary?) -> Void) throws


    /**
       Invokes the post request for lookups

       - parameter breinLookup: lookup object
       - parameter success successBlock: will be invoked in case of success
       - parameter failure failureBlock: will be invoked in case of an error
     */
    func doLookup(breinLookup: BreinLookup,
                  success successBlock: (result: BreinResult?) -> Void,
                  failure failureBlock: (error: NSDictionary?) -> Void) throws

    /**
       Invokes the post request for recommendations

       - parameter breinRecommendation: recommendation object
       - parameter success successBlock: will be invoked in case of success
       - parameter failure failureBlock: will be invoked in case of an error
     */
    func doRecommendation(breinRecommendation: BreinRecommendation,
                          success successBlock: (result: BreinResult?) -> Void,
                          failure failureBlock: (error: NSDictionary?) -> Void) throws

    /**
       Invokes the post request for temporalData

       - parameter breinTemporalData: temporalData object
       - parameter success successBlock: will be invoked in case of success
       - parameter failure failureBlock: will be invoked in case of an error
     */
    func doTemporalDataRequest(breinTemporalData: BreinTemporalData,
                               success successBlock: (result: BreinResult?) -> Void,
                               failure failureBlock: (error: NSDictionary?) -> Void) throws

    /**
       Terminates the rest engine
    */
    func terminate()
}





