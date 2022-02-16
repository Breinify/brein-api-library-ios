//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinConfig {

    //  default endpoint of activity
    static let kDefaultActivityEndpoint: String! = "/activity"

    //  default endpoint of lookup
    static let kDefaultLookupEndpoint: String! = "/lookup"

    //  default endpoint of lookup
    static let kDefaultRecommendationEndpoint: String! = "/recommendation"

    //  default endpoint of lookup
    static let kDefaultTemporalDataEndpoint: String! = "/temporaldata"

    //  default connection timeout
    static let kDefaultConnectionTimeout: Int = 1000

    //  default socket timeout
    static let kDefaultSocketTimeout: Int = 6000

    //  default Breinify base url
    static let kDefaultBaseUrl: String! = "https://api.breinify.com"

    //  BASE URL
    var baseUrl: String! = BreinConfig.kDefaultBaseUrl

    //  contains the api key
    var apiKey: String!

    //  Default REST client
    var restEngineType: BreinEngineType! = BreinEngineType.URLSession

    //  contains the activity endpoint (default = ACTIVITY_ENDPOINT)
    var activityEndpoint: String! = kDefaultActivityEndpoint

    //  contains the activity endpoint (default = ACTIVITY_ENDPOINT)
    var recommendationEndpoint: String! = kDefaultRecommendationEndpoint

    //  contains the lookup endpoint (default = LOOKUP_ENDPOINT)
    var lookupEndpoint: String! = kDefaultLookupEndpoint

    //  contains the temporalData endpoint (default = DEFAULT_TEMPORAL_DATA_ENDPOINT)
    var temporalDataEndpoint: String! = kDefaultTemporalDataEndpoint

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

    // with location Manager
    var locationManagerUsage: Bool = false

    // resend failed activities
    var resendFailedActivities: Bool = false

    // standard ctor
    public init() {
        initValues()
        initEngine()
    }

    ///  init with
    ///
    /// - Parameter apiKey: contains the apiKey
    convenience public init(_ apiKey: String!) {
        self.init()
        setApiKey(apiKey)
        initEngine()
    }

    /**
       init with

       - parameter apiKey: contains the apiKey
       - parameter secret: contains the secret
    */
    convenience public init(_ apiKey: String!, secret: String!) {
        self.init(apiKey)
        setSecret(secret)
        initEngine()
    }

    /**
       init with

       - parameter apiKey: contains the apiKey
       - parameter secret: contains the secret
       - parameter breinEngineType: contains the engine  
    */
    convenience public init(_ apiKey: String!,
                            secret: String!,
                            breinEngineType: BreinEngineType!) {

        self.init(apiKey, secret: secret)
        setRestEngineType(breinEngineType)
        initEngine()
    }

    // initializes the values
    func initValues() {
        lookupEndpoint = BreinConfig.kDefaultLookupEndpoint
        activityEndpoint = BreinConfig.kDefaultActivityEndpoint
        recommendationEndpoint = BreinConfig.kDefaultRecommendationEndpoint
        temporalDataEndpoint = BreinConfig.kDefaultTemporalDataEndpoint
        baseUrl = BreinConfig.kDefaultBaseUrl
        connectionTimeout = BreinConfig.kDefaultConnectionTimeout
        socketTimeout = BreinConfig.kDefaultSocketTimeout
        category = ""

        // default rest-engine
        setRestEngineType(BreinEngineType.URLSession)
    }

    // initializes the rest engine
    public func initEngine() {
        breinEngine = BreinEngine(engineType: getRestEngineType())
    }

    public func build() throws -> BreinifyExecutor {
        let breinifyExecutor = BreinifyExecutor()
        breinifyExecutor.setConfig(self)

        initEngine()
        return breinifyExecutor
    }

    public func getBaseUrl() -> String! {
        baseUrl
    }

    @discardableResult
    public func setBaseUrl(_ baseUrl: String!) throws -> BreinConfig {
        if baseUrl != nil {
            self.baseUrl = baseUrl
            try checkBaseUrl(baseUrl)
        }
        return self
    }

    public func checkBaseUrl(_ baseUrl: String!) throws {
        if false == isUrlValid(baseUrl) {
            let msg: String! = "BreinConfig issue. Value for BaseUrl is not valid. Value is: " + baseUrl
            throw BreinError.BreinConfigurationError(msg)
        }
    }

    public func getRestEngineType() -> BreinEngineType! {
        restEngineType
    }

    @discardableResult
    public func setRestEngineType(_ restEngineType: BreinEngineType!) -> BreinConfig {
        self.restEngineType = restEngineType
        return self
    }

    public func getBreinEngine() -> BreinEngine! {
        breinEngine
    }

    @discardableResult
    public func setApiKey(_ apiKey: String!) -> BreinConfig {
        self.apiKey = apiKey
        return self
    }

    public func getApiKey() -> String! {
        apiKey
    }

    public func getUrl() -> String! {
        baseUrl
    }

    public func getConnectionTimeout() -> Int {
        connectionTimeout
    }

    public func getSocketTimeout() -> Int {
        socketTimeout
    }

    @discardableResult
    public func setSocketTimeout(_ socketTimeout: Int) -> BreinConfig {
        self.socketTimeout = socketTimeout
        return self
    }

    @discardableResult
    public func setConnectionTimeout(_ connectionTimeout: Int) -> BreinConfig {
        self.connectionTimeout = connectionTimeout
        return self
    }

    public func getActivityEndpoint() -> String! {
        activityEndpoint
    }

    @discardableResult
    public func setActivityEndpoint(_ activityEndpoint: String!) -> BreinConfig {
        self.activityEndpoint = activityEndpoint
        return self
    }

    public func getRecommendationEndpoint() -> String! {
        recommendationEndpoint
    }

    @discardableResult
    public func setRecommendationEndpoint(_ recommendationEndpoint: String!) -> BreinConfig {
        self.recommendationEndpoint = recommendationEndpoint
        return self
    }

    public func getLookupEndpoint() -> String! {
        lookupEndpoint
    }

    @discardableResult
    public func setLookupEndpoint(_ lookupEndpoint: String!) -> BreinConfig {
        self.lookupEndpoint = lookupEndpoint
        return self
    }

    public func getTemporalDataEndpoint() -> String! {
        temporalDataEndpoint
    }

    @discardableResult
    public func setTemporalDataEndpoint(_ temporalDataEndpoint: String!) -> BreinConfig {
        self.temporalDataEndpoint = temporalDataEndpoint
        return self
    }

    public func getSecret() -> String! {
        secret
    }

    @discardableResult
    public func setSecret(_ secret: String!) -> BreinConfig {
        self.secret = secret
        return self
    }

    public func getCategory() -> String! {
        category
    }

    @discardableResult
    public func setCategory(_ category: String!) -> BreinConfig {
        self.category = category
        return self
    }

    public func shutdownEngine() {
        if breinEngine?.getRestEngine() != nil {
            // invoke termination of the engine
            breinEngine.getRestEngine().terminate()
        }
    }

    public func isUrlValid(_ url: String!) -> Bool {
        BreinUtil.isUrlValid(url)
    }

    @discardableResult
    public func setWithLocationManagerUsage(_ usage: Bool!) -> BreinConfig {
        locationManagerUsage = usage
        return self
    }

    public func getWithLocationManagerUsage() -> Bool! {
        locationManagerUsage
    }

    @discardableResult
    public func setResendFailedActivities(_ resendFailedActivities: Bool!) -> BreinConfig {
        self.resendFailedActivities = resendFailedActivities
        return self
    }

    public func getResendFailedActivities() -> Bool! {
        resendFailedActivities
    }
}
