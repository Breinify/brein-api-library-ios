//
//  BreinifyManager.swift
//
//

import Foundation
import UserNotifications

open class BreinifyManager: NSObject, UNUserNotificationCenterDelegate {
    
    typealias apiSuccess = (_ result: BreinResult?) -> Void
    typealias apiFailure = (_ error: NSDictionary?) -> Void
    
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    /// configuration part
    var userEmail: String?
    var userId: String?
    
    // contains the sessionId of the app
    var appSessionId: String?
    
    /// contains the deviceToken
    var deviceToken: String = ""
    
    let backGroundTimeInterval = 60.0
    
    // each app user is associated with a Breinify User
    var appUser = BreinUser()
    
    /// singleton
    public static let sharedInstance: BreinifyManager = {
        let instance = BreinifyManager()

        /// read userdata
        instance.readAndInitUserDefaults()

        // configure session
        instance.configureSession()
        
        return instance
    }()
    
    // Can't init is singleton
    override
    private init() {
    }
    
    public func setToken(_ deviceToken: String?) {
        self.deviceToken = deviceToken!
    }
    
    public func getDeviceToken() -> String? {
        return self.deviceToken
    }
    
    public func setEmail(_ userEmail: String?) {
        self.userEmail = userEmail!
    }
    
    public func getUserEmail() -> String? {
        return self.userEmail
    }
    
    public func getUserId() -> String? {
        return self.userId
    }
    
    /// setup configuration
    private func initialize() {
        
        /// read userdata
        readAndInitUserDefaults()
        
        // configure session
        configureSession()
    }

    public func configure(apiKey: String, secret: String) {
        /// create the configuration object
        let breinConfig = BreinConfig(apiKey, secret: secret)

        /// set configuration
        Breinify.setConfig(breinConfig)
    }
    
    public func configureSession() {
        self.appSessionId = UUID().uuidString
    }
    
    func sendLocationInformation() {
        BreinifyManager.sharedInstance.sendLocationInfo()
    }
    
    public func sendActivity(_ activityType: String, additionalContent: [String: AnyObject]) {
        
        // create a user you are interested in
        if self.userEmail != nil {
            appUser.setEmail(self.userEmail)
        }
        
        // callback in case of success
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            // log.debug("Api Success : result is:\n \(result!)")
        }
        
        // callback in case of a failure
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            // log.debug("Api Failure: error is:\n \(error)")
        }
        
        if !additionalContent.isEmpty {
            // add additional content
            // log.debug("Additional Content is: \(additionalContent)")
            appUser.setAdditional("notification", map: additionalContent)
        }
        
        // invoke activity call
        do {
            try Breinify.activity(appUser,
                                  activityType: activityType,
                                  category: "",
                                  description: "from iOS device",
                                  success: successBlock,
                                  failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }
        
        if !additionalContent.isEmpty {
            // remove additional data
            appUser.clearAdditional()
        }
    }
    
    public func sendIndentityInfo() {
        // log.debug("sendIndentityInfo called")
        sendActivity("identity", additionalContent: [:])
    }
    
    public func sendLocationInfo() {
        // log.debug("sendLocationInfo called")
        sendActivity("sendLoc", additionalContent: [:])
    }
    
    public func readAndInitUserDefaults() {
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: "Breinify.userEmail") {
            self.userEmail = email
        }
        
        if let uuid = defaults.string(forKey: "Breinify.userId") {
            self.userId = uuid
        } else {
            // generate unique user id
            self.userId = UUID().uuidString
        }
        
        // set unique user id
        self.appUser.setUserId(self.userId)
    }
    
    public func saveUserDefaults() {
        
        let defaults = UserDefaults.standard
        defaults.setValue(getUserEmail(), forKey: "Breinify.userEmail")
        
        defaults.setValue(getUserId(), forKey: "Breinify.userId")
        defaults.synchronize()
    }
    
    
    // Background Task Handling
    func reinstateBackgroundTask() {
        // log.debug("reinstateBackgroundTask called")
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }
    
    func registerBackgroundTask() {
        // log.debug("registerBackgroundTask called")
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        // log.debug("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    // Notifications
    //
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // log.debug("willPresent: User Info = \(notification.request.content.userInfo)")
        // completionHandler([.alert, .badge, .sound])
        completionHandler([])
        
        let aps = notification.request.content.userInfo["aps"] as! [String: AnyObject]
        
        self.sendActivity("openedPushNotification", additionalContent: aps)
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // log.debug("didReceive called with content: \(response)")
        completionHandler()
        
        let aps = response.notification.request.content.userInfo["aps"] as! [String: AnyObject]
        self.sendActivity("openedPushNotification", additionalContent: aps)
    }
    
    func registerPushNotifications() {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // iOS Lifecycle

    // This method allows you to perform any final initialization before the app
    // is displayed to the user
    public func didFinishLaunchingWithOptions(apiKey: String, secret: String) {

        // configure the API key
        self.configure(apiKey: apiKey, secret: secret)

        // register PushNotifications
        self.registerPushNotifications()

        // init background Timer
        let interval = BreinifyManager.sharedInstance.backGroundTimeInterval
        updateTimer = Timer.scheduledTimer(timeInterval: interval, target: self,
                                           selector: #selector(sendLocationInformation), userInfo: nil, repeats: true)
    }

    // This method should be invoked from the Application Delegate method
    //      applicationDidEnterBackground
    // It ensures that background processing is invoked
    public func applicationDidEnterBackground() {
        // additional stuff
        NotificationCenter.default.removeObserver(self)
        
        registerBackgroundTask()
        
        // remove sessionId - mandatory when app is running in background
        appUser.setSessionId("")
    }

    // This method should be invoked from the Application Delegate method
    //      applicationDidBecomeActive
    // 
    public func applicationDidBecomeActive() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // set session id
        appUser.setSessionId(self.appSessionId)
    }

    // This method should be invoked from the Application Delegate method
    //      applicationWillTerminate
    //
    public func applicationWillTerminate() {
        
        // shutdown the engine
        Breinify.shutdown()
        
        // save defaults
        saveUserDefaults()
    }

    // This method should be invoked from the Application Delegate method
    //      didRegisterForRemoteNotificationsWithDeviceToken
    public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) -> String! {
        
        // 1. read deviceToken
        self.deviceToken = retrieveDeviceToken(deviceToken)
        
        // 2. register within API
        appUser.setDeviceToken(self.deviceToken)
        
        // 3. send identify to the engine
        sendIndentityInfo()
        
        return self.deviceToken
    }

    // This method should be invoked from the Application Delegate method
    //      didReceiveRemoteNotification
    // 
    public func didReceiveRemoteNotification(_ notification: [AnyHashable: Any], _ controller: UIKit.UIViewController?) {
        
        // log.debug("BreinifyManager - received notification is: \(notification)")
        print(notification)
        var message = "The message"
        
        if let aps = notification["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let msg = alert["message"] as? String {
                    message = msg
                }
            } else if let alert = aps["alert"] as? String {
                //Do stuff
                print(alert)
                message = alert
            }
        }
        
        let notDic = notification["aps"] as! [String: AnyObject]
        self.sendActivity("receivedPushNotification", additionalContent: notDic)
        
        // Todo: extract the message
        let refreshAlert = UIAlertController(title: "Breinify Notification",
                                             message: message,
                                             preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))

        if controller != nil {
            controller?.present(refreshAlert, animated: true, completion: nil)
        }
    }

    // This method should be invoked from the Application delegate method
    //      didFailToRegisterForRemoteNotificationsWithError
    // 
    public func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        
    }
    
    // Retrieves the device token
    private func retrieveDeviceToken(_ deviceToken: Data) -> String {
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""
        
        for i in 0 ..< deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        return token
    }
}
