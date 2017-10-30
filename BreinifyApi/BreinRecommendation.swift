//
//  BreinRecommendation.swift
//
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
        self.setNumberOfRecommendations(numberOfRecommendation)
    }

    public init(breinUser: BreinUser?) {
        super.init()
        self.setUser(breinUser)
    }

    public init(breinUser: BreinUser?, numberOfRecommendation: Int!) {
        super.init()
        self.setUser(breinUser)
        self.setNumberOfRecommendations(numberOfRecommendations)
    }

    public func getCategory() -> String! {
        return self.category
    }

    @discardableResult
    public func setCategory(_ category: String!) -> BreinRecommendation {
        self.category = category
        return self
    }

    public func getNumberOfRecommendations() -> Int {
        return self.numberOfRecommendations
    }

    @discardableResult
    public func setNumberOfRecommendations(_ numOfRecommendations: Int) -> BreinRecommendation {
        self.numberOfRecommendations = numOfRecommendations
        return self
    }

    /**
      Contains the recommendation endpoint
    */
    override public func getEndPoint() -> String! {
        return getConfig()?.getRecommendationEndpoint()
    }

    /**
       creates a dictionary that will be used for the request.

       - returns: Dictionary
     */
    override public func prepareJsonRequest() -> [String: AnyObject]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        // firstly user data
        if let breinUser = getUser() {
            var userData = [String: AnyObject]()
            breinUser.prepareUserRequest(&userData, breinConfig: self.getConfig())
            requestData["user"] = userData as AnyObject?
        }

        //  recommendation data
        var recommendationData = [String: AnyObject]()

        // optional field
        if let category = self.getCategory() {
            recommendationData["recommendationCategory"] = category as AnyObject?
        }

        // mandatory field
        recommendationData["numRecommendations"] = self.getNumberOfRecommendations() as AnyObject?

        requestData["recommendation"] = recommendationData as AnyObject?;

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
                .setNumberOfRecommendations(self.getNumberOfRecommendations())
                .setCategory(self.getCategory())

        // clone from base class
        clonedBreinRecommendation.cloneBase(self)

        return clonedBreinRecommendation
    }

    /**
      Create signature for recommendation request
    */
    public override func createSignature() throws -> String! {
        let message = String(getUnixTimestamp())
        return try BreinUtil.generateSignature(message, secret: getConfig()?.getSecret())
    }
}
