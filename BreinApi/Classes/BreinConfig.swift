//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

class BreinConfig {

    //  default endpoint of activity
    let DEFAULT_ACTIVITY_ENDPOINT: String! = "/activity"

    //  default endpoint of lookup
    let DEFAULT_LOOKUP_ENDPOINT: String! = "/lookup"

    //  default connection timeout
    let DEFAULT_CONNECTION_TIMEOUT: Int = 1000

    //  default socket timeout
    let DEFAULT_SOCKET_TIMEOUT: Int = 6000

    //  default validation
    var DEFAULT_VALIDATE: Bool = true

    //  default breinify base url
    let DEFAULT_BASE_URL: String! = "https://api.breinify.com"

    //  BASE URL
    var baseUrl: String!

    //  contains the api key
    var apiKey: String!

    //  Default REST client
    var restEngineType: BreinEngineType! = BreinEngineType.ALAMOFIRE

    //  contains the activity endpoint (default = ACTIVITY_ENDPOINT)
    var activityEndpoint: String!

    //  contains the lookup endpoint (default = LOOKUP_ENDPOINT)
    var lookupEndpoint: String!

    //  connection timeout
    var connectionTimeout: Int!

    //  Engine with default value
    var breinEngine: BreinEngine!

    //  socket timeout
    var socketTimeout: Int!

    //  contains the secret
    var secret: String!

    init() {
        self.initValues()
    }

    init(apiKey: String!, baseUrl: String!) throws {
        self.initValues()
        self.setApiKey(apiKey)
        try setBaseUrl(baseUrl)
        self.setRestEngineType(BreinEngineType.NO_ENGINE)
    }

    init(apiKey: String!,
         baseUrl: String!,
         breinEngineType: BreinEngineType!) throws {

        self.initValues()
        self.setApiKey(apiKey)
        try setBaseUrl(baseUrl)
        self.setRestEngineType(breinEngineType)
        try self.initEngine()
    }

    func initValues() {
        self.lookupEndpoint = DEFAULT_LOOKUP_ENDPOINT
        self.activityEndpoint = DEFAULT_ACTIVITY_ENDPOINT
        self.baseUrl = DEFAULT_BASE_URL
        self.connectionTimeout = DEFAULT_CONNECTION_TIMEOUT
        self.socketTimeout = DEFAULT_SOCKET_TIMEOUT
    }

    func initEngine() throws {
        self.breinEngine = try BreinEngine(engineType: getRestEngineType())
    }

    func build() throws -> BreinifyExecutor {
        let breinifyExecutor = BreinifyExecutor()
        breinifyExecutor.setConfig(self)
        try self.initEngine()
        return breinifyExecutor
    }

    func getBaseUrl() -> String! {
        return baseUrl
    }

    func setBaseUrl(baseUrl: String!) throws -> BreinConfig {
        if baseUrl != nil {
            self.baseUrl = baseUrl
            try checkBaseUrl(baseUrl)
        }
        return self
    }

    func checkBaseUrl(baseUrl: String!) throws {
        if false == isUrlValid(baseUrl) {
            let msg: String! = "BreinConfig issue. Value for BaseUrl is not valid. Value is: " + baseUrl
            throw BreinError.BreinConfigurationError(msg)
        }
    }

    func getRestEngineType() -> BreinEngineType! {
        return self.restEngineType
    }

    func setRestEngineType(restEngineType: BreinEngineType!) -> BreinConfig {
        self.restEngineType = restEngineType
        return self
    }

    func getBreinEngine() -> BreinEngine! {
        return self.breinEngine
    }

    func setApiKey(apiKey: String!) -> BreinConfig {
        self.apiKey = apiKey
        return self
    }

    func getApiKey() -> String! {
        return apiKey
    }

    func getUrl() -> String! {
        return baseUrl
    }

    func getConnectionTimeout() -> Int {
        return connectionTimeout
    }

    func getSocketTimeout() -> Int {
        return socketTimeout
    }

    func setSocketTimeout(socketTimeout: Int) {
        self.socketTimeout = socketTimeout
    }

    func setConnectionTimeout(connectionTimeout: Int) {
        self.connectionTimeout = connectionTimeout
    }

    func getActivityEndpoint() -> String! {
        return activityEndpoint
    }

    func setActivityEndpoint(activityEndpoint: String!) -> BreinConfig {
        self.activityEndpoint = activityEndpoint
        return self
    }

    func getLookupEndpoint() -> String! {
        return lookupEndpoint
    }

    func setLookupEndpoint(lookupEndpoint: String!) -> BreinConfig {
        self.lookupEndpoint = lookupEndpoint
        return self
    }

    func getSecret() -> String! {
        return secret
    }

    func setSecret(secret: String!) -> BreinConfig {
        self.secret = secret
        return self
    }

    func shutdownEngine() {
        if ((self.breinEngine?.getRestEngine()) != nil) {
            // invoke termination of the engine
            self.breinEngine.getRestEngine().terminate()
        }

    }

    func isUrlValid(url: String!) -> Bool {
        return BreinUtil.isUrlValid(url)
    }

}
