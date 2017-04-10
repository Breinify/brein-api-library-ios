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
        - register the pushNotifictaions
        - initializes the background timer
        
    */
    open class func didFinishLaunchingWithOptions(apiKey: String, secret: String, backgroundInterval: Double? = nil) {
        
        BreinifyManager.sharedInstance.didFinishLaunchingWithOptions(apiKey: apiKey, secret: secret, backgroundInterval: backgroundInterval)
    }
    
    /**

        This method is invoked when the app is moving to background mode. 
    */
    open class func applicationDidEnterBackground() {
        
        BreinifyManager.sharedInstance.applicationDidEnterBackground()
    }

    /**

        This method is invoked when the app is going to terminate.

    */
    open class func applicationWillTerminate() {
        
        BreinifyManager.sharedInstance.applicationWillTerminate()
    }

    /**

        This method is invoked from APNS (Apple Push Notification Service) and provides the
        device token for the iOS device

    */
    open class func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) ->  String! {
        
        let token = BreinifyManager.sharedInstance.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        return token
    }

    /**
        
        This method is invoked when it was not possible to register for remote notifications

    */
    open class func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        
        BreinifyManager.sharedInstance.didFailToRegisterForRemoteNotificationsWithError(error)
    }

    /**
    
        This method is invoked when a remove notification is triggered

    */
    open class func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any], _ viewController: UIViewController?) {
        
        BreinifyManager.sharedInstance.didReceiveRemoteNotification(userInfo, viewController)
    }

    /**

        This method is invoked when the App becomes active again.

    */
    open class func applicationDidBecomeActive() {
        
        BreinifyManager.sharedInstance.applicationDidBecomeActive()
        
    }
    
}
