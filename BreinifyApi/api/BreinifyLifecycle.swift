//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//
// Intended to support the iOS Application Lifecycle and provides convenient access
// to userEmail and userId

import Foundation

public extension Breinify {

    /**

        This method is invoked close before the first view will be displayed.

        It invokes the appropriate method from the BreinifyManager and:
        - configures the API key
        - register the pushNotifications
        - initializes the background timer
        
    */
    class func didFinishLaunchingWithOptions(apiKey: String, secret: String, backgroundInterval: Double? = 60) {
        BreinifyManager.shared.didFinishLaunchingWithOptions(apiKey: apiKey,
                secret: secret, backgroundInterval: backgroundInterval)
    }

    /**

        This method is invoked when the app is moving to background mode. 
    */
    @objc
    class func applicationDidEnterBackground() {
        BreinifyManager.shared.applicationDidEnterBackground()
    }

    /**

        This method is invoked when the app is going to terminate.

    */
    @objc
    class func applicationWillTerminate() {
        BreinifyManager.shared.applicationWillTerminate()
    }

    /**

        This method is invoked from APNS (Apple Push Notification Service) and provides the
        device token for the iOS device

    */
    @objc
    class func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) -> String! {
        let token = BreinifyManager.shared.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        return token
    }

    /**
        
        This method is invoked when it was not possible to register for remote notifications

    */
    @objc
    class func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        BreinifyManager.shared.didFailToRegisterForRemoteNotificationsWithError(error)
    }

    /**
    
        This method is invoked when a remote notification is triggered

    */
    @objc
    class func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        BreinifyManager.shared.didReceiveRemoteNotification(userInfo)
    }

    /**

        This method is invoked when the App becomes active again.

    */
    @objc
    class func applicationDidBecomeActive() {
        BreinifyManager.shared.applicationDidBecomeActive()
    }

    /**
        BreinifyManager contains an instance of BreinUser in order to support
        the settings of userId. The userId is part of the request.

    */
    @objc
    class func setUserId(_ userId: String) {
        BreinifyManager.shared.setUserId(userId)
    }

    @objc
    class func getUserId() -> String? {
        BreinifyManager.shared.getUserId()
    }

    /**
        BreinifyManager contains an instance of BreinUser in order to support
        the settings of user email. The user email is part of the request.

    */
    @objc
    class func setEmail(_ email: String) {
        BreinifyManager.shared.setEmail(email)
    }

    @objc
    class func getEmail() -> String? {
        BreinifyManager.shared.getUserEmail()
    }
}
