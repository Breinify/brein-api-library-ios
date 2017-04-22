//
//  Sample.swift
//  BreinifyApi
//
//

import UIKit
import UserNotifications
import BreinifyApi


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Configure Breinify ApiKey and secret and register for push notifications
        Breinify.didFinishLaunchingWithOptions(apiKey: "938D-3120-64DD-413F-BB55-6573-90CE-473A",
                secret: "utakxp7sm6weo5gvk7cytw==")
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Breinify.applicationDidEnterBackground()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Breinify.applicationDidBecomeActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Breinify.applicationWillTerminate()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // register device Token within the API
        _ = Breinify.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Breinify.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Breinify.didReceiveRemoteNotification(userInfo)
        
        completionHandler(.newData)
    }
    
}


