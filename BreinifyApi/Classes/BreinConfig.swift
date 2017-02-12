//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinConfig {

    //  default endpoint of activity
    static let DEFAULT_ACTIVITY_ENDPOINT: String! = "/activity"

    //  default endpoint of lookup
    static let DEFAULT_LOOKUP_ENDPOINT: String! = "/lookup"

    //  default endpoint of lookup
    static let DEFAULT_RECOMMENDATION_ENDPOINT: String! = "/recommendation"

    //  default endpoint of lookup
    static let DEFAULT_TEMPORAL_DATA_ENDPOINT: String! = "/temporaldata"

    //  default connection timeout
    static let DEFAULT_CONNECTION_TIMEOUT: Int = 1000

    //  default socket timeout
    static let DEFAULT_SOCKET_TIMEOUT: Int = 6000

    //  default breinify base url
    static let DEFAULT_BASE_URL: String! = "https://api.breinify.com"

    //  BASE URL
    var baseUrl: String!

    //  contains the api key
    var apiKey: String!

    //  Default REST client
    var restEngineType: BreinEngineType! = BreinEngineType.ALAMOFIRE

    //  contains the activity endpoint (default = ACTIVITY_ENDPOINT)
    var activityEndpoint: String! = DEFAULT_ACTIVITY_ENDPOINT

    //  contains the activity endpoint (default = ACTIVITY_ENDPOINT)
    var recommendationEndpoint: String! = DEFAULT_RECOMMENDATION_ENDPOINT

    //  contains the lookup endpoint (default = LOOKUP_ENDPOINT)
    var lookupEndpoint: String! = DEFAULT_LOOKUP_ENDPOINT

    //  contains the temporalData endpoint (default = DEFAULT_TEMPORAL_DATA_ENDPOINT)
    var temporalDataEndpoint: String! = DEFAULT_TEMPORAL_DATA_ENDPOINT

    //  connection timeout
    var connectionTimeout: Int!

    //  Engine with default value
    var breinEngine: BreinEngine!

    //  socket timeout
    var socketTimeout: Int!

    //  contains the secret
    var secret: String!

    // default category
    var category: String!

    // standard ctor
    public init() throws {
        self.initValues()
        try self.initEngine()
    }

    //
    convenience public init(apiKey: String!) throws {

        do {
            try self.init();

            self.setApiKey(apiKey);
            try self.initEngine()
        } catch {
            throw BreinError.BreinRuntimeError("could not initialize init")
        }
    }

    //
    convenience public init(apiKey: String!, secret: String!) throws {

        do {
            try self.init(apiKey: apiKey);

            setSecret(secret)
            try self.initEngine()
        } catch {
            throw BreinError.BreinRuntimeError("could not initialize init")
        }
    }

    // 
    convenience public init(apiKey: String!,
                            secret: String!,
                            breinEngineType: BreinEngineType!) throws {

        do {
            try self.init(apiKey: apiKey, secret: secret)

            self.setRestEngineType(breinEngineType)
            try self.initEngine()
        } catch {
            throw BreinError.BreinRuntimeError("could not initialize init")
        }
    }

    // initializes the values
    func initValues() {
        self.lookupEndpoint = BreinConfig.DEFAULT_LOOKUP_ENDPOINT
        self.activityEndpoint = BreinConfig.DEFAULT_ACTIVITY_ENDPOINT
        self.recommendationEndpoint = BreinConfig.DEFAULT_RECOMMENDATION_ENDPOINT
        self.temporalDataEndpoint = BreinConfig.DEFAULT_TEMPORAL_DATA_ENDPOINT
        self.baseUrl = BreinConfig.DEFAULT_BASE_URL
        self.connectionTimeout = BreinConfig.DEFAULT_CONNECTION_TIMEOUT
        self.socketTimeout = BreinConfig.DEFAULT_SOCKET_TIMEOUT
        self.category = ""

        // default rest-engine
        setRestEngineType(BreinEngineType.ALAMOFIRE)
    }

    public func initEngine() throws {
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

    public func setSocketTimeout(socketTimeout: Int) -> BreinConfig {
        self.socketTimeout = socketTimeout
        return self
    }

    public func setConnectionTimeout(connectionTimeout: Int) -> BreinConfig {
        self.connectionTimeout = connectionTimeout
        return self
    }

    public func getActivityEndpoint() -> String! {
        return self.activityEndpoint
    }

    public func setActivityEndpoint(activityEndpoint: String!) -> BreinConfig {
        self.activityEndpoint = activityEndpoint
        return self
    }

    public func getRecommendationEndpoint() -> String! {
        return self.recommendationEndpoint
    }

    public func setecommendationEndpoint(recommendationEndpoint: String!) -> BreinConfig {
        self.recommendationEndpoint = recommendationEndpoint
        return self
    }

    public func getLookupEndpoint() -> String! {
        return lookupEndpoint
    }

    public func setLookupEndpoint(lookupEndpoint: String!) -> BreinConfig {
        self.lookupEndpoint = lookupEndpoint
        return self
    }

    public func getTemporalDataEndpoint() -> String! {
        return temporalDataEndpoint
    }

    public func setTemporalDataEndpoint(temporalDataEndpoint: String!) -> BreinConfig {
        self.temporalDataEndpoint = temporalDataEndpoint
        return self
    }

    public func getSecret() -> String! {
        return secret
    }

    public func setSecret(secret: String!) -> BreinConfig {
        self.secret = secret
        return self
    }

    public func getCategory() -> String! {
        return category
    }

    public func setCategory(category: String!) -> BreinConfig {
        self.category = category
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
