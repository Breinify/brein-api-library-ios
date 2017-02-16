//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinTemporalData: BreinBase, ISecretStrategy {

    public func temporalData(breinUser: BreinUser!,
                             sign: Bool,
                             success successBlock: BreinEngine.apiSuccess,
                             failure failureBlock: BreinEngine.apiFailure) throws {

        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        setBreinUser(breinUser)

        return try getBreinEngine().performTemporalDataRequest(self,
                success: successBlock,
                failure: failureBlock)
    }

    override public func prepareJsonRequest() -> [String: AnyObject]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getBreinUser() {
            var userData = [String: AnyObject]()
            breinUser.prepareUserRequest(&userData, breinConfig: self.getConfig())
            requestData["user"] = userData
        }

        // base level data...
        self.prepareBaseRequestData(&requestData)
                
        return requestData
    }

    override public func getEndPoint() -> String! {
        return getConfig().getTemporalDataEndpoint()
    }

    public override func createSignature() -> String! {
        let localDateTime = getBreinUser().getLocalDateTime()
        let paraLocalDateTime = localDateTime == nil ? "" : localDateTime

        let timezone = getBreinUser().getTimezone()
        let paraTimezone = timezone == nil ? "" : timezone

        let message = String(getUnixTimestamp()) +
                "-" +
                paraLocalDateTime +
                "-" +
                paraTimezone

        var signature = ""
        do {
            signature = try BreinUtil.generateSignature(message, secret: getConfig().getSecret())
        } catch {
            print("Ups: Error while trying to generate signature")
        }

        return signature
    }

}

