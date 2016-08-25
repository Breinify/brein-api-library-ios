//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

extension IRestEngine {

    func validateBreinBase(breinBase: BreinBase!) throws {
        guard breinBase != nil else {
            throw BreinError.BreinRuntimeError("activity or lookup object is nil")
        }
    }

    func validateConfig(breinBase: BreinBase!) throws {
        guard breinBase?.getConfig() != nil else {
            throw BreinError.BreinRuntimeError("Breinconfig not set!")
        }
    }

    func getFullyQualifiedUrl(breinBase: BreinBase!) throws -> String {
        if let baseUrl = breinBase?.getConfig()?.getUrl() {
            return baseUrl + breinBase.getEndPoint()

        } else {
            throw BreinError.BreinRuntimeError("URL is not set")
        }
    }

    func getRequestBody(breinBase: BreinBase!) throws -> [String:AnyObject]! {
        return breinBase.prepareJsonRequest()
    }

    func validate(breinBase: BreinBase!) throws {
        try validateBreinBase(breinBase)
        try validateConfig(breinBase)
    }


}
