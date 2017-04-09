//
// Created by Marco 
//
// Intended to support the iOS Application Lifecycle


import Foundation

public extension Breinify {

    open class func didFinishLaunchingWithOptions(apiKey: String, secret: String, backgroundInterval: Double? = nil) {
        
        BreinifyManager.sharedInstance.didFinishLaunchingWithOptions(apiKey: apiKey, secret: secret, backgroundInterval: backgroundInterval)
    }


    open class func applicationDidEnterBackground() {
        
        BreinifyManager.sharedInstance.applicationDidEnterBackground()
    }
    
    open class func applicationWillTerminate() {
        
        BreinifyManager.sharedInstance.applicationWillTerminate()
    }
    
    open class func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) ->  String! {
        
        let token = BreinifyManager.sharedInstance.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        return token
    }
    
    open class func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        
        BreinifyManager.sharedInstance.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    open class func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any], _ viewController: UIViewController?) {
        
        BreinifyManager.sharedInstance.didReceiveRemoteNotification(userInfo, viewController)
    }
    
    open class func applicationDidBecomeActive() {
        
        BreinifyManager.sharedInstance.applicationDidBecomeActive()
        
    }
    
}
