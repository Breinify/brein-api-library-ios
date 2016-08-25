//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinEngine {

    typealias apiSuccess = (result:BreinResult?) -> Void
    typealias apiFailure = (error:NSDictionary?) -> Void

    var restEngine: IRestEngine!

    init(engineType: BreinEngineType) throws {
        switch engineType {
        case BreinEngineType.ALAMOFIRE:
            self.restEngine = AlamofireEngine()
        case BreinEngineType.NO_ENGINE:
            throw BreinError.BreinConfigurationError("no rest engine configured.")
        }
    }

    func sendActivity(activity: BreinActivity!,
                      success successBlock: BreinEngine.apiSuccess,
                      failure failureBlock: BreinEngine.apiFailure) throws {
        if activity != nil {
            try restEngine.doRequest(activity,
                    success: successBlock,
                    failure: failureBlock)
        }
    }

    func performLookUp(breinLookup: BreinLookup!,
                       success successBlock: apiSuccess,
                       failure failureBlock: apiFailure) throws {
        if breinLookup != nil {
            return try restEngine.doLookup(breinLookup,
                    success: successBlock,
                    failure: failureBlock)
        }
    }

    func getRestEngine() -> IRestEngine! {
        return restEngine
    }

    func configure(breinConfig: BreinConfig!) {
        restEngine.configure(breinConfig)
    }

}