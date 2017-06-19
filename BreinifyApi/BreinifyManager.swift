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
    var user_Id: String?

    // contains the sessionId of the app
    var appSessionId: String?

    /// contains the deviceToken
    var deviceToken: String = ""

    /// interval in seconds
    let kBackGroundTimeInterval = 60.0

    /// permission to send locationUpdate
    var hasPermissionToSendLocationUpdates = true

    /// singleton
    public static let sharedInstance: BreinifyManager = {
        let instance = BreinifyManager()

        /// read user data
        instance.readAndInitUserDefaults()

        // configure session
        instance.configureSession()

        // set a breinUser to work on
        // Breinify.setBreinUser(BreinUser())

        return instance
    }()

    // Can't init the singleton
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

    public func setUserId(_ userId: String) {
        self.user_Id = userId
    }

    public func getUserId() -> String? {
        return self.user_Id
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
            Breinify.getBreinUser().setEmail(self.userEmail)
        }

        if self.getUserId() != nil {
            Breinify.getBreinUser().setUserId(self.getUserId())
        }

        // callback in case of success
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            // print("Api Success : result is:\n \(result!)")
        }

        // callback in case of a failure
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            // print("Api Failure: error is:\n \(error)")
        }

        if !additionalContent.isEmpty {
            // add additional content
            // print("Additional Content is: \(additionalContent)")
            Breinify.getBreinUser().setAdditional("notification", map: additionalContent)
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
            print("Error is: \(error)")
        }

        if !additionalContent.isEmpty {
            // remove additional data
            _ = Breinify.getBreinUser().clearAdditional()
        }
    }

    public func sendIndentityInfo() {
        // print("sendIndentityInfo called")
        sendActivity("identity", additionalContent: [:])
    }

    /**

        Send location information in interval to the backend.
        This functionality is only available if the user has
        given the permission to include location data. So this
        will be checked.

    */
    public func sendLocationInfo() {
        // print("sendLocationInfo called")

        if hasPermissionToSendLocationUpdates == true {
            sendActivity("sendLoc", additionalContent: [:])
        }
    }

    public func readAndInitUserDefaults() {
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: "Breinify.userEmail") {
            self.userEmail = email
        }

        if let uuid = defaults.string(forKey: "Breinify.userId") {
            self.user_Id = uuid
        }

        // set unique user id
        Breinify.getBreinUser().setUserId(self.user_Id)
    }

    public func saveUserDefaults() {

        let defaults = UserDefaults.standard
        defaults.setValue(getUserEmail(), forKey: "Breinify.userEmail")

        defaults.setValue(getUserId(), forKey: "Breinify.userId")
        defaults.synchronize()
    }


    // Background Task Handling
    func reinstateBackgroundTask() {
        // print("reinstateBackgroundTask called")
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }

    func registerBackgroundTask() {
        // print("registerBackgroundTask called")
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }

    func endBackgroundTask() {
        // print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }

    // Notifications
    //
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // print("willPresent: User Info = \(notification.request.content.userInfo)")
        // completionHandler([.alert, .badge, .sound])
        completionHandler([])

        let aps = notification.request.content.userInfo["aps"] as! [String: AnyObject]

        self.sendActivity("openedPushNotification", additionalContent: aps)

        // call BreinNotification-Handler
        Breinify.getNotificationHandler()?.willPresent(notification)
    }

    // Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // print("didReceive called with content: \(response)")
        completionHandler()

        let aps = response.notification.request.content.userInfo["aps"] as! [String: AnyObject]
        self.sendActivity("openedPushNotification", additionalContent: aps)

        // call BreinNotification-Handler
        Breinify.getNotificationHandler()?.didReceive(response)
    }

    func registerPushNotifications() {

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()

            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            center.delegate = self

            UIApplication.shared.applicationIconBadgeNumber = 0

            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
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

        // init background Timer take parameter if set, otherwise default
        let interval = backgroundInterval ?? BreinifyManager.sharedInstance.kBackGroundTimeInterval

        updateTimer = Timer.scheduledTimer(timeInterval: interval, target: self,
                selector: #selector(sendLocationInformation), userInfo: nil, repeats: true)

        // check if unsent message are there
        BreinRequestManager.sharedInstance.loadMissedRequests()
    }

    // This method should be invoked from the Application Delegate method
    //      applicationDidEnterBackground
    // It ensures that background processing is invoked
    public func applicationDidEnterBackground() {
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

        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask),
                name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        // set session id
        Breinify.getBreinUser().setSessionId(self.appSessionId)
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
        Breinify.getBreinUser().setDeviceToken(self.deviceToken)

        // 3. send identify to the engine
        sendIndentityInfo()

        return self.deviceToken
    }

    // This method should be invoked from the Application Delegate method
    //      didReceiveRemoteNotification
    // 
    public func didReceiveRemoteNotification(_ notification: [AnyHashable: Any]) {

        print("BreinifyManager - received notification is: \(notification)")

        let notDic = notification["aps"] as! [String: AnyObject]
        self.sendActivity("receivedPushNotification", additionalContent: notDic)

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

        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        return token
    }
}
