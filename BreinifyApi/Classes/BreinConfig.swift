//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinConfig {

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

    public init() {
        self.initValues()
    }

    public init(apiKey: String!, baseUrl: String!) throws {
        self.initValues()
        self.setApiKey(apiKey)
        try setBaseUrl(baseUrl)
        self.setRestEngineType(BreinEngineType.NO_ENGINE)
    }

    public init(apiKey: String!,
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

    public func build() throws -> BreinifyExecutor {
        let breinifyExecutor = BreinifyExecutor()
        breinifyExecutor.setConfig(self)
        try self.initEngine()
        return breinifyExecutor
    }

    public func getBaseUrl() -> String! {
        return baseUrl
    }

    public func setBaseUrl(baseUrl: String!) throws -> BreinConfig {
        if baseUrl != nil {
            self.baseUrl = baseUrl
            try checkBaseUrl(baseUrl)
        }
        return self
    }

    public func checkBaseUrl(baseUrl: String!) throws {
        if false == isUrlValid(baseUrl) {
            let msg: String! = "BreinConfig issue. Value for BaseUrl is not valid. Value is: " + baseUrl
            throw BreinError.BreinConfigurationError(msg)
        }
    }

    public func getRestEngineType() -> BreinEngineType! {
        return self.restEngineType
    }

    public func setRestEngineType(restEngineType: BreinEngineType!) -> BreinConfig {
        self.restEngineType = restEngineType
        return self
    }

    public func getBreinEngine() -> BreinEngine! {
        return self.breinEngine
    }

    public func setApiKey(apiKey: String!) -> BreinConfig {
        self.apiKey = apiKey
        return self
    }

    public func getApiKey() -> String! {
        return apiKey
    }

    public func getUrl() -> String! {
        return baseUrl
    }

    public func getConnectionTimeout() -> Int {
        return connectionTimeout
    }

    public func getSocketTimeout() -> Int {
        return socketTimeout
    }

    public func setSocketTimeout(socketTimeout: Int) {
        self.socketTimeout = socketTimeout
    }

    public func setConnectionTimeout(connectionTimeout: Int) {
        self.connectionTimeout = connectionTimeout
    }

    public func getActivityEndpoint() -> String! {
        return activityEndpoint
    }

    public func setActivityEndpoint(activityEndpoint: String!) -> BreinConfig {
        self.activityEndpoint = activityEndpoint
        return self
    }

    public func getLookupEndpoint() -> String! {
        return lookupEndpoint
    }

    public func setLookupEndpoint(lookupEndpoint: String!) -> BreinConfig {
        self.lookupEndpoint = lookupEndpoint
        return self
    }

    public func getSecret() -> String! {
        return secret
    }

    public func setSecret(secret: String!) -> BreinConfig {
        self.secret = secret
        return self
    }

    public func shutdownEngine() {
        if ((self.breinEngine?.getRestEngine()) != nil) {
            // invoke termination of the engine
            self.breinEngine.getRestEngine().terminate()
        }

    }

    public func isUrlValid(url: String!) -> Bool {
        return BreinUtil.isUrlValid(url)
    }

}
