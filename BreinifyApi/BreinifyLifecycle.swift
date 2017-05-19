//
// Created by Marco 
//
// Intended to support the iOS Application Lifecycle

import Foundation

public extension Breinify {

    /**

        This method is invoked close before the first view will be displayed.

        It invokes the appropriate method from the BreinifyManager and:
        - configures the API key
        - register the pushNotifications
        - initializes the background timer
        
    */
    public class func didFinishLaunchingWithOptions(apiKey: String, secret: String, backgroundInterval: Double? = 60) {
        
        BreinifyManager.sharedInstance.didFinishLaunchingWithOptions(apiKey: apiKey, secret: secret, backgroundInterval: backgroundInterval)
    }
    
    /**

        This method is invoked when the app is moving to background mode. 
    */
    public class func applicationDidEnterBackground() {
        
        BreinifyManager.sharedInstance.applicationDidEnterBackground()
    }

    /**

        This method is invoked when the app is going to terminate.

    */
    public class func applicationWillTerminate() {
        
        BreinifyManager.sharedInstance.applicationWillTerminate()
    }

    /**

        This method is invoked from APNS (Apple Push Notification Service) and provides the
        device token for the iOS device

    */
    public class func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) ->  String! {
        
        let token = BreinifyManager.sharedInstance.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        return token
    }

    /**
        
        This method is invoked when it was not possible to register for remote notifications

    */
    public class func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        
        BreinifyManager.sharedInstance.didFailToRegisterForRemoteNotificationsWithError(error)
    }

    /**
    
        This method is invoked when a remove notification is triggered

    */
    public class func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        
        BreinifyManager.sharedInstance.didReceiveRemoteNotification(userInfo)
    }

    /**

        This method is invoked when the App becomes active again.

    */
    public class func applicationDidBecomeActive() {
        
        BreinifyManager.sharedInstance.applicationDidBecomeActive()
        
    }

    public class func setUserId(_ userId: String) {

        BreinifyManager.sharedInstance.setUserId(userId)
        
    }

    public class func setEmail(_ email: String) {

        BreinifyManager.sharedInstance.setEmail(email)
        
    }
    
}
