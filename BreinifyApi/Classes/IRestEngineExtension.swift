//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

extension IRestEngine {

    /// validates the breinbase object
    func validateBreinBase(breinBase: BreinBase!) throws {
        guard breinBase != nil else {
            throw BreinError.BreinRuntimeError("request object is nil")
        }
    }

    /// validates the config
    func validateConfig(breinBase: BreinBase!) throws {
        guard breinBase?.getConfig() != nil else {
            throw BreinError.BreinRuntimeError("Breinconfig not set!")
        }
    }

    /// returns the url depending of the request type (e.g. activity, recommendation...)
    func getFullyQualifiedUrl(breinBase: BreinBase!) throws -> String {
        if let baseUrl = breinBase?.getConfig()?.getUrl() {
            return baseUrl + breinBase.getEndPoint()

        } else {
            throw BreinError.BreinRuntimeError("URL is not set")
        }
    }

    /// returns request body
    func getRequestBody(breinBase: BreinBase!) throws -> [String:AnyObject]! {
        return breinBase.prepareJsonRequest()
    }

    /// validates base and config
    func validate(breinBase: BreinBase!) throws {
        try validateBreinBase(breinBase)
        try validateConfig(breinBase)
    }

}
