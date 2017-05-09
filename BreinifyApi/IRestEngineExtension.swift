//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

extension IRestEngine {

    /// validates the breinbase object
    func validateBreinBase(_ breinBase: BreinBase!) throws {
        guard breinBase != nil else {
            throw BreinError.BreinRuntimeError("request object is nil")
        }
    }

    /// validates the config
    func validateConfig(_ breinBase: BreinBase!) throws {
        guard breinBase?.getConfig() != nil else {
            throw BreinError.BreinRuntimeError("Breinconfig not set!")
        }
    }

    /// returns the url depending of the request type (e.g. activity, recommendation...)
    func getFullyQualifiedUrl(_ breinBase: BreinBase!) throws -> String {
        if let baseUrl = breinBase?.getConfig()?.getUrl() {
            return baseUrl + breinBase.getEndPoint()

        } else {
            throw BreinError.BreinRuntimeError("URL is not set")
        }
    }

    /// returns request body
    func getRequestBody(_ breinBase: BreinBase!) throws -> [String:AnyObject]! {
        return breinBase.prepareJsonRequest()
    }

    /// validates base and config
    func validate(_ breinBase: BreinBase!) throws {
        try validateBreinBase(breinBase)
        try validateConfig(breinBase)
    }

}
