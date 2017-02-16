//
//  BreinRecommendation.swift
//
//


import Foundation

public class BreinRecommendation: BreinBase, ISecretStrategy {

    static let DEFAULT_NUMBER_OF_RECOMMENDATION = 3

    /**
     * contains the number of recommendations
     */
    var numberOfRecommendations: Int!

    /**
     * contains the category for the recommendation
     */
    var category: String?

    public override init() {
        super.init()
        self.numberOfRecommendations = BreinRecommendation.DEFAULT_NUMBER_OF_RECOMMENDATION
    }

    public init(numberOfRecommendation: Int!) {
        super.init()
        setNumberOfRecommendations(numberOfRecommendation)
    }

    public init(breinUser: BreinUser) {
        super.init()
        self.setBreinUser(breinUser)
    }

    public init(breinUser: BreinUser, numberOfRecommendation: Int!) {
        super.init()
        self.setBreinUser(breinUser)
        self.setNumberOfRecommendations(numberOfRecommendations)
    }

    public func getCategory() -> String! {
        return self.category
    }

    public func setCategory(category: String!) -> BreinRecommendation {
        self.category = category
        return self
    }

    public func getNumberOfRecommendations() -> Int {
        return self.numberOfRecommendations
    }

    public func setNumberOfRecommendations(numOfRecommendations: Int) -> BreinRecommendation {
        self.numberOfRecommendations = numOfRecommendations
        return self
    }

    override public func getEndPoint() -> String! {
        return getConfig().getRecommendationEndpoint()
    }

    /**
     * creates a dictionary that will be used for the request.
     *
     * @return Dictionary
     */
    override public func prepareJsonRequest() -> [String: AnyObject]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        // firstly user data
        if let breinUser = getBreinUser() {
            var userData = [String: AnyObject]()
            breinUser.prepareUserRequest(&userData, breinConfig: self.getConfig())
            requestData["user"] = userData
        }

        //  recommendation data
        var recommendationData = [String: AnyObject]()

        // optional field
        if let category = self.getCategory() {
            recommendationData["recommendationCategory"] = category
        }

        // mandatory field
        recommendationData["numRecommendations"] = self.getNumberOfRecommendations()

        requestData["recommendation"] = recommendationData;

        // base level data...
        prepareBaseRequestData(&requestData);

        return requestData
    }

    public override func createSignature() throws -> String! {
        let message = String(getUnixTimestamp())
        return try BreinUtil.generateSignature(message, secret: getConfig().getSecret())
    }
}
