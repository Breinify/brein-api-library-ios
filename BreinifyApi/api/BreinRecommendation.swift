//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinRecommendation: BreinBase, ISecretStrategy {

    /// default number of recommendations
    static let cDefaultNumberOfRecommendation = 3

    ///  contains the number of recommendations
    var numberOfRecommendations: Int = BreinRecommendation.cDefaultNumberOfRecommendation

    /// contains the category for the recommendation
    var category: String?

    public override init() {
        super.init()
    }

    public init(numberOfRecommendation: Int!) {
        super.init()
        setNumberOfRecommendations(numberOfRecommendation)
    }

    public init(breinUser: BreinUser?) {
        super.init()
        setUser(breinUser)
    }

    public init(breinUser: BreinUser?, numberOfRecommendation: Int!) {
        super.init()
        setUser(breinUser)
        setNumberOfRecommendations(numberOfRecommendations)
    }

    public func getCategory() -> String! {
        category
    }

    @discardableResult
    public func setCategory(_ category: String!) -> BreinRecommendation {
        self.category = category
        return self
    }

    public func getNumberOfRecommendations() -> Int {
        numberOfRecommendations
    }

    @discardableResult
    public func setNumberOfRecommendations(_ numOfRecommendations: Int) -> BreinRecommendation {
        numberOfRecommendations = numOfRecommendations
        return self
    }

    /**
      Contains the recommendation endpoint
    */
    override public func getEndPoint() -> String! {
        getConfig()?.getRecommendationEndpoint()
    }

    /**
       creates a dictionary that will be used for the request.

       - returns: Dictionary
     */
    override public func prepareJsonRequest() -> [String: Any]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: Any]()

        // firstly user data
        if let breinUser = getUser() {
            var userData = [String: Any]()
            breinUser.prepareUserRequest(&userData, breinConfig: getConfig())
            requestData["user"] = userData as Any?
        }

        //  recommendation data
        var recommendationData = [String: Any]()

        // optional field
        if let category = getCategory() {
            recommendationData["recommendationCategory"] = category as Any?
        }

        // mandatory field
        recommendationData["numRecommendations"] = getNumberOfRecommendations() as Any?

        requestData["recommendation"] = recommendationData as Any?;

        // base level data...
        prepareBaseRequestData(&requestData);

        return requestData
    }

    /**
      Used to create a clone of the recommendation object. This is important in order to prevent
      concurrency issues.

      - returns: the clone of the activity object
    */
    public func clone() -> BreinRecommendation {

        // create a new recommendation object
        let clonedBreinRecommendation = BreinRecommendation()
                .setNumberOfRecommendations(getNumberOfRecommendations())
                .setCategory(getCategory())

        // clone from base class
        clonedBreinRecommendation.cloneBase(self)

        return clonedBreinRecommendation
    }

    /**
      Create signature for recommendation request
    */
    public override func createSignature() throws -> String! {
        let message = String(getUnixTimestamp())
        do {
            return try BreinUtil.generateSignature(message, secret: getConfig()?.getSecret())
        } catch {
            BreinLogger.shared.log(error.localizedDescription)
            return ""
        }
    }
}
