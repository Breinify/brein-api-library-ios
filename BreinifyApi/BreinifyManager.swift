//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation
import UserNotifications

open class BreinifyManager: NSObject, UNUserNotificationCenterDelegate {

    typealias apiSuccess = (_ result: BreinResult?) -> Void
    typealias apiFailure = (_ error: NSDictionary?) -> Void

    /// some constants
    static let kActivityTypeIdentify = "identify"
    static let kActivityTypeSendLocation = "sendLoc"
    static let kNotificationLabel = "notification"

    static let kUserDefaultUserEmail = "Breinify.userEmail"
    static let kUserDefaultUserId = "Breinify.userId"

    /// background handling
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid

    /// configuration part
    var userEmail: String?
    var user_Id: String?

    // contains the sessionId of the app
    var appSessionId: String?

    /// contains the deviceToken
    var deviceToken: String = ""

    /// interval in seconds with default of 60 seconds
    let kBackGroundTimeInterval = 60.0

    /// permission to send locationUpdate
    var hasPermissionToSendLocationUpdates = true

    /// singleton
    public static let shared: BreinifyManager = {
        let instance = BreinifyManager()

        initialize()

        /// read user data
        instance.readAndInitUserDefaults()

        // configure session
        instance.configureSession()

        return instance
    }()

    // Can't init the singleton
    override
    private init() {
    }

    public func setDeviceToken(_ deviceToken: String?) {
        self.deviceToken = deviceToken!
    }

    public func getDeviceToken() -> String? {
        self.deviceToken
    }

    public func setEmail(_ userEmail: String?) {
        self.userEmail = userEmail!
    }

    public func getUserEmail() -> String? {
        self.userEmail
    }

    public func setUserId(_ userId: String) {
        self.user_Id = userId
    }

    public func getUserId() -> String? {
        return self.user_Id
    }

    /// setup configuration
    private func initialize() {

        // read saved user data
        readAndInitUserDefaults()

        // configure session
        configureSession()

        // invoke ipAddress detection to be prepared for the next call
        _ = BreinIpInfo.shared
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

    @objc func sendLocationInformation() {
        BreinifyManager.shared.sendLocationInfo()
    }

    public func sendActivity(_ activityType: String, additionalContent: [String: Any]) {
        BreinLogger.shared.log("sendActivity invoked")

        // create a user you are interested in
        if self.userEmail != nil {
            Breinify.getBreinUser().setEmail(self.userEmail)
        }

        if self.getUserId() != nil {
            Breinify.getBreinUser().setUserId(self.getUserId())
        }

        // callback in case of success
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            BreinLogger.shared.log("sendActivity success")
        }

        // callback in case of a failure
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            BreinLogger.shared.log("sendActivity failure with error: \(String(describing: error))")
        }

        if !additionalContent.isEmpty {
            // add additional content
            // print("Additional Content is: \(additionalContent)")
            Breinify.getBreinUser().setAdditional(BreinifyManager.kNotificationLabel, map: additionalContent)
        }

        // invoke activity call
        do {
            try Breinify.activity(Breinify.getBreinUser(),
                    activityType: activityType,
                    nil,
                    "from iOS device",
                    successBlock,
                    failureBlock)
        } catch {
            BreinLogger.shared.log("Error is: \(error)")
        }

        if !additionalContent.isEmpty {
            // remove additional data
            _ = Breinify.getBreinUser().clearAdditional()
        }
    }

    public func sendIdentifyInfo() {
        BreinLogger.shared.log("sendIdentifyInfo invoked")
        sendActivity(BreinifyManager.kActivityTypeIdentify, additionalContent: [:])
    }

    /**

        Send location information in interval to the backend.
        This functionality is only available if the user has
        given the permission to include location data. So this
        will be checked.

    */
    public func sendLocationInfo() {
        BreinLogger.shared.log("sendLocation called at \(BreinUtil.currentTime())")

        if hasPermissionToSendLocationUpdates == true {
            sendActivity(BreinifyManager.kActivityTypeSendLocation, additionalContent: [:])
        }
    }

    /**
        Reads the user defaults
    */
    public func readAndInitUserDefaults() {
        BreinLogger.shared.log("readAndInitUserDefaults called")

        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: BreinifyManager.kUserDefaultUserEmail) {
            self.userEmail = email
            Breinify.getBreinUser().setEmail(email)
        }

        if let uuid = defaults.string(forKey: BreinifyManager.kUserDefaultUserId) {
            self.user_Id = uuid
        } else {
            // not set yet generate an UUID
            self.user_Id = UUID().uuidString
        }

        // set unique user id
        Breinify.getBreinUser().setUserId(self.user_Id)

        BreinLogger.shared.log("UserId: \(String(describing: self.user_Id)) - Email: \(String(describing: self.userEmail))")
    }

    /**

        Saves the user defaults and sends an identify activity to the engine
    */
    public func saveUserDefaults() {
        BreinLogger.shared.log("saveUserDefaults called")

        let defaults = UserDefaults.standard
        defaults.setValue(getUserEmail(), forKey: BreinifyManager.kUserDefaultUserEmail)
        defaults.setValue(getUserId(), forKey: BreinifyManager.kUserDefaultUserId)
        defaults.synchronize()

        // send a new identify => credentials might have changed
        sendIdentifyInfo()
    }

    // Background Task Handling
    @objc func reinstateBackgroundTask() {
        BreinLogger.shared.log("reinstateBackgroundTask called")
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskIdentifier.invalid) {
            registerBackgroundTask()
        }
    }

    func registerBackgroundTask() {
        BreinLogger.shared.log("registerBackgroundTask called")
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        // assert(backgroundTask != UIBackgroundTaskInvalid)
    }

    func endBackgroundTask() {
        BreinLogger.shared.log("endBackgroundTask called")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }

    // Notifications
    //
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        BreinLogger.shared.log("UserNotification willPresent invoked with notification: \(notification)")

        let aps = notification.request.content.userInfo["aps"] as! [String: Any]

        self.sendActivity("openedPushNotification", additionalContent: aps)

        // call BreinNotification-Handler
        Breinify.getNotificationHandler()?.willPresent(notification)

        completionHandler([.alert, .badge, .sound])
    }

    // Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        // print("didReceive called with content: \(response)")
        BreinLogger.shared.log("UserNotification didReceive invoked with response: \(response).")

        let aps = response.notification.request.content.userInfo["aps"] as! [String: Any]
        self.sendActivity("openedPushNotification", additionalContent: aps)

        // call BreinNotification-Handler
        Breinify.getNotificationHandler()?.didReceive(response)

        completionHandler()
    }

    func registerPushNotifications() {
        BreinLogger.shared.log("registerNotification invoked")

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()

            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            center.delegate = self

            UIApplication.shared.applicationIconBadgeNumber = 0

            /*
            let viewAction = UNNotificationAction(
                    identifier: BreinPushIdentifiers.viewAction, title: "View",
                    options: [.foreground])

            let newsCategory = UNNotificationCategory(
                    identifier: BreinPushIdentifiers.newsCategory, actions: [viewAction],
                    intentIdentifiers: [], options: [])

            
            UNUserNotificationCenter.current()
                    .setNotificationCategories([newsCategory])
               */

            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge],
                        categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }

    // iOS Lifecycle

    // This method allows you to perform any final initialization before the app
    // is displayed to the user
    public func didFinishLaunchingWithOptions(apiKey: String, secret: String, backgroundInterval: Double?) {

        // configure the API key
        self.configure(apiKey: apiKey, secret: secret)

        // register PushNotifications
        self.registerPushNotifications()

        let locUsage = Breinify.getConfig().getWithLocationManagerUsage()
        if locUsage == true {
            // init background Timer take parameter if set, otherwise default
            let interval = backgroundInterval ?? BreinifyManager.shared.kBackGroundTimeInterval

            updateTimer = Timer.scheduledTimer(timeInterval: interval, target: self,
                    selector: #selector(sendLocationInformation), userInfo: nil, repeats: true)
        }

    }

    // This method should be invoked from the Application Delegate method
    //      applicationDidEnterBackground
    // It ensures that background processing is invoked
    public func applicationDidEnterBackground() {

        BreinLogger.shared.log("applicationDidEnterBackground called")

        // additional stuff
        NotificationCenter.default.removeObserver(self)

        registerBackgroundTask()

        // remove sessionId - mandatory when app is running in background
        Breinify.getBreinUser().setSessionId("")
    }

    // This method should be invoked from the Application Delegate method
    //      applicationDidBecomeActive
    //
    public func applicationDidBecomeActive() {

        BreinLogger.shared.log("applicationDidBecomeActive called")

        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask),
                name: UIApplication.didBecomeActiveNotification, object: nil)

        // set session id
        Breinify.getBreinUser().setSessionId(self.appSessionId)
    }

    // This method should be invoked from the Application Delegate method
    //      applicationWillTerminate
    //
    public func applicationWillTerminate() {

        BreinLogger.shared.log("applicationWillTerminate called")

        // shutdown the engine
        Breinify.shutdown()

        // save defaults
        saveUserDefaults()
    }

    // This method should be invoked from the Application Delegate method
    //      didRegisterForRemoteNotificationsWithDeviceToken
    public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) -> String! {

        BreinLogger.shared.log("didRegisterForRemoteNotificationsWithDeviceToken called")

        // 1. read deviceToken
        self.deviceToken = retrieveDeviceToken(deviceToken)

        // 2. register within API
        Breinify.getBreinUser().setDeviceToken(self.deviceToken)

        // 3. send identify to the engine
        sendIdentifyInfo()

        return self.deviceToken
    }

    // This method should be invoked from the Application Delegate method
    //      didReceiveRemoteNotification
    //
    public func didReceiveRemoteNotification(_ notification: [AnyHashable: Any]) {
        BreinLogger.shared.log("didReceiveRemoteNotification called with notification: \(notification)")

        let notDic = notification["aps"] as! [String: Any]
        self.sendActivity("receivedPushNotification", additionalContent: notDic)
    }

    public func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        BreinLogger.shared.log("didFailToRegisterForRemoteNotificationsWithError called")
    }

    // Retrieves the device token
    public func retrieveDeviceToken(_ deviceToken: Data) -> String {
        let apnsToken = (deviceToken.reduce("") {
            $0 + String(format: "%02X", $1)
        })

        return apnsToken
    }
}
