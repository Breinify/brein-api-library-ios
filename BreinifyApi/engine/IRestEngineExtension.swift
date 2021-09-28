//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
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

        let config = breinBase.getConfig()

        if let apiKey = config?.getApiKey() {
            if apiKey.isEmpty {
                throw BreinError.BreinRuntimeError("apiKey is empty!")
            }
        } else {
            throw BreinError.BreinRuntimeError("apiKey not set!")
        }

        if let secret = config?.getSecret() {
            if secret.isEmpty {
                throw BreinError.BreinRuntimeError("secret is empty!")
            }
        } else {
            throw BreinError.BreinRuntimeError("secret not set!")
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
    func getRequestBody(_ breinBase: BreinBase!) throws -> [String: Any]! {
        breinBase.prepareJsonRequest()
    }

    /// validates base and config
    func validate(_ breinBase: BreinBase!) throws {
        try validateBreinBase(breinBase)
        try validateConfig(breinBase)
    }

}
