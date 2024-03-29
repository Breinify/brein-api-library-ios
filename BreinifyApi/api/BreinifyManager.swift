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

    static let kUserDefaultUserEmail = "Breinify.userEmail"
    static let kUserDefaultUserId = "Breinify.userId"

    /// background handling
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid

    /// configuration part
    var userEmail: String?
    var userId: String?

    // contains the sessionId of the app
    var appSessionId: String?

    /// contains the deviceToken
    var deviceToken: String = ""

    /// interval in seconds with default of 60 seconds
    let kBackGroundTimeInterval = 60.0

    /// permission to send locationUpdate
    var hasPermissionToSendLocationUpdates = true

    /// should register push notification
    var shouldRegisterPushNotification: Bool = true

    /// singleton
    public static let shared: BreinifyManager = {
        let instance = BreinifyManager()

        initialize()

        /// read user data
        instance.readAndInitUserDefaults()

        // configure session
        instance.configureSession()

        // detect ip
        // _ = BreinIpInfo.shared

        return instance
    }()

    public func willRegisterPushNotification(_ shouldRegister: Bool) {
        shouldRegisterPushNotification = shouldRegister
    }

    public func hasRegisteredPushNotification() -> Bool {
        shouldRegisterPushNotification
    }

    // Can't init the singleton
    override
    private init() {
    }

    public func setDeviceToken(_ deviceToken: String?) {
        self.deviceToken = deviceToken!
    }

    public func getDeviceToken() -> String? {
        deviceToken
    }

    public func setEmail(_ userEmail: String?) {
        self.userEmail = userEmail!
    }

    public func getUserEmail() -> String? {
        userEmail
    }

    public func setUserId(_ userId: String) {
        self.userId = userId
    }

    public func getUserId() -> String? {
        userId
    }

    /// setup configuration
    private func initialize() {

        // read saved user data
        readAndInitUserDefaults()

        // configure session
        configureSession()

        // invoke ipAddress detection to be prepared for the next call
        //_ = BreinIpInfo.shared
    }

    public func configureSession() {
        appSessionId = UUID().uuidString
    }

    @objc func sendLocationInformation() {
        BreinifyManager.shared.sendLocationInfo()
    }

    public func sendActivity(_ activityType: String, additionalActivityTagContent: [String: Any]?) {
        BreinLogger.shared.log("Breinify sendActivity invoked")

        // create a user you are interested in
        if userEmail != nil {
            Breinify.getBreinUser().setEmail(userEmail)
        }

        if getUserId() != nil {
            Breinify.getBreinUser().setUserId(getUserId())
        }

        if additionalActivityTagContent != nil {
            Breinify.breinActivity.setTagsDic(additionalActivityTagContent)
        }

        // callback in case of success
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            BreinLogger.shared.log("Breinify sendActivity success")
        }

        // callback in case of a failure
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            BreinLogger.shared.log("Breinify sendActivity failure with error: \(String(describing: error))")
        }

        if additionalActivityTagContent != nil {
            Breinify.breinActivity.setTagsDic(additionalActivityTagContent)
        }

        // invoke activity call
        do {
            try Breinify.activity(Breinify.getBreinUser(),
                    activityType: activityType,
                    nil,
                    "",
                    successBlock,
                    failureBlock)
        } catch {
            BreinLogger.shared.log("Breinify activity error is: \(error)")
        }

    }

    public func sendIdentifyInfo() {
        BreinLogger.shared.log("Breinify sendIdentifyInfo invoked")
        let tagsDic = collectAdditionalTagInformation()
        sendActivity(BreinifyManager.kActivityTypeIdentify, additionalActivityTagContent: tagsDic)
    }

    public func collectAdditionalTagInformation() -> [String: Any] {

        var dictionary = [String: Any]()

        // collect time of app installation
        let urlToDocumentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let installDate = (try! FileManager.default.attributesOfItem(atPath: urlToDocumentsFolder.path)[FileAttributeKey.creationDate])
        BreinLogger.shared.log("Breinify - this app was installed by the user on \(installDate ?? "not provided")")

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let installDateAsString = df.string(from: installDate as! Date)
        dictionary["appInstallation"] = installDateAsString

        // collect version of app
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        dictionary["appVersion"] = version

        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String]!
        dictionary["appName"] = appName

        // collect version of Breinify SDK
        dictionary["Breinify-SDK"] = Breinify.getVersion()

        return dictionary
    }

    /**

        Send location information in interval to the backend.
        This functionality is only available if the user has
        given the permission to include location data. So this
        will be checked.

    */
    public func sendLocationInfo() {
        BreinLogger.shared.log("Breinify sendLocation called at \(BreinUtil.currentTime())")

        if hasPermissionToSendLocationUpdates == true {
            sendActivity(BreinifyManager.kActivityTypeSendLocation, additionalActivityTagContent: [:])
        }
    }

    /**
        Reads the user defaults
    */
    public func readAndInitUserDefaults() {
        BreinLogger.shared.log("Breinify readAndInitUserDefaults called")

        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: BreinifyManager.kUserDefaultUserEmail) {
            userEmail = email
            Breinify.getBreinUser().setEmail(email)
        }

        if let uuid = defaults.string(forKey: BreinifyManager.kUserDefaultUserId) {
            userId = uuid
        } else {
            // not set yet generate an UUID
            userId = UUID().uuidString
        }

        // set unique user id
        Breinify.getBreinUser().setUserId(userId)

        BreinLogger.shared.log("Breinify readAndInitUserDefault with UserId: \(String(describing: userId)) - Email: \(String(describing: userEmail))")
    }

    /**

        Saves the user defaults and sends an identify activity to the engine
    */
    public func saveUserDefaults() {
        BreinLogger.shared.log("Breinify saveUserDefaults called")

        let defaults = UserDefaults.standard
        defaults.setValue(getUserEmail(), forKey: BreinifyManager.kUserDefaultUserEmail)
        defaults.setValue(getUserId(), forKey: BreinifyManager.kUserDefaultUserId)
        defaults.synchronize()

        // send a new identify => credentials might have changed
        sendIdentifyInfo()
    }

    // Background Task Handling
    @objc func reinstateBackgroundTask() {
        BreinLogger.shared.log("Breinify reinstateBackgroundTask called")
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskIdentifier.invalid) {
            registerBackgroundTask()
        }
    }

    func registerBackgroundTask() {
        BreinLogger.shared.log("Breinify registerBackgroundTask called")
        let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as! UIApplication
        backgroundTask = application.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }

    func endBackgroundTask() {
        BreinLogger.shared.log("Breinify endBackgroundTask called")
        let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as! UIApplication
        application.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }

    // Notifications
    //
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        BreinLogger.shared.log("Breinify UserNotification willPresent invoked with notification: \(notification)")

        // due to a possible URLSession connection time out we wait half a little bit before message is sent
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [self] in
            let campaignNotificationDic = getCampaignContent(notification.request.content.userInfo)
            sendActivity(BreinActivityType.RECEIVED_PUSH_NOTIFICATION.rawValue, additionalActivityTagContent: campaignNotificationDic)
        }

        completionHandler([.alert, .badge, .sound])
    }

    // Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {

        BreinLogger.shared.log("Breinify UserNotification didReceive invoked with response: \(response)")

        let campaignNotificationDic = getCampaignContent(response.notification.request.content.userInfo)
        sendActivity(BreinActivityType.OPEN_PUSH_NOTIFICATION.rawValue, additionalActivityTagContent: campaignNotificationDic)

        BreinLogger.shared.log("Breinify invoking handleIncomingNotificationContent from didReceive method")
        handleIncomingNotificationContent(response.notification.request.content.userInfo)

        completionHandler()
    }

    public func handleDidReceiveNotification(_ userInfo: [AnyHashable: Any]) {

        BreinLogger.shared.log("Breinify handleDidReceiveNotification invoked with notification: \(userInfo)")

        let campaignNotificationDic = getCampaignContent(userInfo)
        sendActivity(BreinActivityType.OPEN_PUSH_NOTIFICATION.rawValue, additionalActivityTagContent: campaignNotificationDic)

        BreinLogger.shared.log("Breinify invoking handleIncomingNotificationContent from handleDidReceiveNotification method")
        handleIncomingNotificationContent(userInfo)
    }

    @available(iOS 10, *)
    public func handleDidReceiveNotificationResponse(_ response: UNNotificationResponse) {
        BreinLogger.shared.log("Breinify handleDidReceiveNotificationResponse invoked with response: \(response)")
    }

    public func handleWillPresentNotification(_ userInfo: [AnyHashable: Any]) {

        BreinLogger.shared.log("Breinify handleWillPresentNotification invoked with notification: \(userInfo)")

        // due to a possible URLSession connection time out we wait half a little bit before message is sent
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [self] in
            let campaignNotificationDic = getCampaignContent(userInfo)
            sendActivity(BreinActivityType.RECEIVED_PUSH_NOTIFICATION.rawValue, additionalActivityTagContent: campaignNotificationDic)
        }
    }

    private func handleIncomingNotificationContent(_ notification: [AnyHashable: Any]) {
        BreinLogger.shared.log("Breinify handleIncomingNotificationContent invoked with notification: \(notification)")

        let actionNotificationDic = getActionContent(notification)
        guard let unwrappedDic = actionNotificationDic else {
            BreinLogger.shared.log("Breinify handleIncomingNotificationContent - no action content detected on: \(notification)")
            return
        }

        if unwrappedDic.isEmpty == false {

            for (action, parameter) in unwrappedDic {
                BreinLogger.shared.log("Breinify action: \(action) with parameter: \(parameter)")

                if action == "openUrl" {
                    BreinLogger.shared.log("Breinify openUrl action detected")
                    let sharedSelector = NSSelectorFromString("sharedApplication")
                    let openSelector = NSSelectorFromString("openURL:")

                    let urlStr = getUrl(parameter)
                    if urlStr.isEmpty == false {
                        BreinLogger.shared.log("Breinify trying to open url: \(urlStr)")
                        DispatchQueue.main.async {
                            if let urlToOpen = URL(string: urlStr), UIApplication.responds(to: sharedSelector),
                               let shared = UIApplication.perform(sharedSelector)?.takeRetainedValue() as? UIApplication, shared.responds(to: openSelector) {
                                BreinLogger.shared.log("Breinify performing action - urlToOpen is: \(urlToOpen)")
                                shared.perform(openSelector, with: urlToOpen)
                            }
                        }
                    }
                } else if action == "sendActivity" {
                    BreinLogger.shared.log("Breinify sendActivity action detected")
                    // send activity
                    let activityName = getActivityName(parameter)
                    if activityName.isEmpty == false {
                        let tags = getTags(parameter)
                        if tags?.isEmpty == false {
                            // send the activity
                            BreinLogger.shared.log("Breinify sending action detected with name: \(activityName) and tags: \(tags)")
                            BreinifyManager.shared.sendActivity(activityName, additionalActivityTagContent: tags)
                        }
                    }
                }
            }
        }
    }

    /// returns the activity name
    private func getActivityName(_ parameter: Any) -> String {
        if let dict = parameter as? [String: Any] {
            BreinLogger.shared.log("Breinify working on parameter \(parameter)")

            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                  let prettyPrinted = String(data: data, encoding: .utf8) else {
                return ""
            }

            let notiDic = BreinUtil.convertToDictionary(text: prettyPrinted)
            var retVal = ""
            notiDic?.forEach {
                let key = ($0)
                let value = ($1)

                if key.contains("activity") {
                    BreinLogger.shared.log("Breinify activity detected - value is:  \(value)")
                    retVal = value as! String
                }
            }
            return retVal
        }

        return ""
    }

    private func getTags(_ parameter: Any) -> Dictionary<String, Any>? {

        var retVal: Dictionary<String, Any> = [:]
        if let dict = parameter as? [String: Any] {
            BreinLogger.shared.log("Breinify working on parameter \(parameter)")

            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                  let prettyPrinted = String(data: data, encoding: .utf8) else {
                return retVal
            }

            let tagsDic = BreinUtil.convertToDictionary(text: prettyPrinted)
            tagsDic?.forEach {
                let key = ($0)
                let value = ($1)

                if key.contains("tags") {
                    BreinLogger.shared.log("Breinify tags detected - value is:  \(value)")
                    retVal = value as! Dictionary<String, Any>
                }
            }
            return retVal
        }

        return retVal
    }

    private func getUrl(_ parameter: Any) -> String {

        if let dict = parameter as? [String: Any] {
            BreinLogger.shared.log("Breinify working on parameter \(parameter)")

            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                  let prettyPrinted = String(data: data, encoding: .utf8) else {
                return ""
            }

            let notiDic = BreinUtil.convertToDictionary(text: prettyPrinted)
            var retVal = ""
            notiDic?.forEach {
                let key = ($0)
                let value = ($1)

                if key.contains("url") {
                    BreinLogger.shared.log("Breinify url detected - value is:  \(value)")
                    retVal = value as! String
                }
            }
            return retVal
        } else {
            /// it is not a dictionary
            return ""
        }

    }

    public func registerPushNotifications() {
        BreinLogger.shared.log("Breinify registerPushNotifications invoked")

        guard let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication else {
            return
        }

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()

            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            center.delegate = self

            let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as! UIApplication
            application.applicationIconBadgeNumber = 0

            let generalCategory = UNNotificationCategory(identifier: "general", actions: [], intentIdentifiers: [], options: .customDismissAction)

            let remindLaterAction = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: UNNotificationActionOptions(rawValue: 0))
            let acceptAction = UNNotificationAction(identifier: "accept", title: "Accept", options: .foreground)
            let declineAction = UNNotificationAction(identifier: "decline", title: "Decline", options: .destructive)
            let commentAction = UNTextInputNotificationAction(identifier: "comment", title: "Comment", options: .authenticationRequired, textInputButtonTitle: "Send", textInputPlaceholder: "Share your thoughts..")
            let breinifyCategory = UNNotificationCategory(identifier: "breinify", actions: [remindLaterAction, acceptAction, declineAction, commentAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))

            center.setNotificationCategories([generalCategory, breinifyCategory])
            center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
                //granted = yes, if app is authorized for all of the requested interaction types
                //granted = no, if one or more interaction type is disallowed
            }

        } else {
            let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                BreinLogger.shared.log("Breinify notification settings: \(settings)")
            }
        }
    }

    func isBreinifyNotificationExtensionRequest(_ request: Any) -> Bool {

        BreinLogger.shared.log("Breinify isBreinifyNotificationExtensionRequest called with request: \(request)")

        guard let data = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted),
              let stringRequest = String(data: data, encoding: .utf8)?.lowercased() else {
            return false
        }

        if stringRequest.contains("breinify") {
            return true
        }

        return false
    }

    func didReceiveNotificationExtensionRequest(_ request: Any,
                                                bestAttemptContent: Any) {

        if #available(iOS 10.0, *) {
            let notificationRequest = request as! UNNotificationRequest
            let notificationContent = bestAttemptContent as! UNMutableNotificationContent

            BreinLogger.shared.log("Breinify didReceiveNotificationExtensionRequest called with request: \(notificationRequest)")

            notificationContent.title = "\(notificationContent.title) [yeah modified in extensionrequest yeah]"

            guard let content = (notificationRequest.content.mutableCopy() as? UNMutableNotificationContent) else {
                return
            }
            BreinLogger.shared.log("Breinify content is: \(content)")

            guard let apnsData = notificationContent.userInfo["data"] as? [String: Any] else {
                return
            }

            guard let attachmentURL = apnsData["attachment-url"] as? String else {
                return
            }

            guard let imageData = NSData(contentsOf: NSURL(string: attachmentURL)! as URL) else {
                return
            }
            guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "breinify-image.gif", data: imageData, options: nil) else {
                return
            }

            notificationContent.attachments = [attachment]
        }
    }

    func serviceExtensionTimeWillExpire(_ bestAttemptContent: Any) {

        if #available(iOS 10.0, *) {
            let notificationContent = bestAttemptContent as! UNMutableNotificationContent
            BreinifyManager.shared.serviceExtensionTimeWillExpire(notificationContent)
        }

    }

    // iOS Lifecycle

    // This method allows you to perform any final initialization before the app
    // is displayed to the user
    public func didFinishLaunchingWithOptions(apiKey: String, secret: String, backgroundInterval: Double?) {

        let breinConfig = BreinConfig(apiKey, secret: secret)

        /// set configuration
        Breinify.setConfig(breinConfig)

        /// read userdata
        Breinify.readUserDefaults()

        // register PushNotifications
        if hasRegisteredPushNotification() == true {
            registerPushNotifications()
        }

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

        BreinLogger.shared.log("Breinify applicationDidEnterBackground called")

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

        BreinLogger.shared.log("Breinify applicationDidBecomeActive called")

        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask),
                name: UIApplication.didBecomeActiveNotification, object: nil)

        // set session id
        Breinify.getBreinUser().setSessionId(appSessionId)
    }

    // This method should be invoked from the Application Delegate method
    //      applicationWillTerminate
    //
    public func applicationWillTerminate() {

        BreinLogger.shared.log("Breinify applicationWillTerminate called")

        // shutdown the engine
        Breinify.shutdown()

        // save defaults
        saveUserDefaults()
    }

    // This method should be invoked from the Application Delegate method
    //      didRegisterForRemoteNotificationsWithDeviceToken
    public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) -> String! {

        BreinLogger.shared.log("Breinify didRegisterForRemoteNotificationsWithDeviceToken called")

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
        BreinLogger.shared.log("Breinify didReceiveRemoteNotification called with notification: \(notification)")

        // due to a possible URLSession connection time out we wait half a second to send a message
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [self] in
            let campaignNotificationDic = getCampaignContent(notification)
            sendActivity(BreinActivityType.RECEIVED_PUSH_NOTIFICATION.rawValue, additionalActivityTagContent: campaignNotificationDic)
        }
    }

    /// Provides the campaign related content as a dictionary
    ///
    /// - Parameter notification: contains the userInfo from the notification
    /// - Returns: dictionary contains all elements from the campaign node
    private func getCampaignContent(_ notification: [AnyHashable: Any]) -> Dictionary<String, Any>? {
        getContent(notification, content: "campaign")
    }

    /// Provides the action related content as a dictionary
    ///
    /// - Parameter notification: contains the userInfo from the notification
    /// - Returns: dictionary contains all elements from the action node
    private func getActionContent(_ notification: [AnyHashable: Any]) -> Dictionary<String, Any>? {
        getContent(notification, content: "action")
    }

    private func getContent(_ notification: [AnyHashable: Any], content: String) -> Dictionary<String, Any>? {

        guard let data = try? JSONSerialization.data(withJSONObject: notification, options: .prettyPrinted),
              let prettyPrinted = String(data: data, encoding: .utf8) else {
            return nil
        }

        do {
            var retVal: Dictionary<String, Any> = [:]
            let notiDic = BreinUtil.convertToDictionary(text: prettyPrinted)
            notiDic?.forEach {
                let key = ($0).lowercased()
                if key.contains("breinify") {
                    BreinLogger.shared.log("Breinify Tag detected in notification for content: \(content)")
                    if let innerValue = ($1) as? String {

                        let innerDic = BreinUtil.convertToDictionary(text: innerValue)
                        innerDic?.forEach {
                            let key = $0
                            let val = $1
                            if key.contains(content) {
                                if let contentDic = val as? Dictionary<String, Any> {
                                    retVal = contentDic
                                    BreinLogger.shared.log("Breinify content (\(content)) is \(contentDic)")
                                }
                            }
                        }
                    }
                }
            }

            return retVal
        }

    }

    public func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        BreinLogger.shared.log("Breinify didFailToRegisterForRemoteNotificationsWithError called")
    }

    // Retrieves the device token
    public func retrieveDeviceToken(_ deviceToken: Data) -> String {
        let apnsToken = (deviceToken.reduce("") {
            $0 + String(format: "%02X", $1)
        })

        return apnsToken
    }
}

@available(iOS 10.0, *)
extension UNNotificationAttachment {
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject: AnyObject]?) -> UNNotificationAttachment? {

        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let fileURLPath = NSURL(fileURLWithPath: NSTemporaryDirectory())
        let tmpSubFolderURL = fileURLPath.appendingPathComponent(tmpSubFolderName, isDirectory: true)

        do {
            try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL!, options: [])
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL!, options: options)
            return imageAttachment
        } catch let error {
            BreinLogger.shared.log("Breinify notification attachment error \(error)")
        }

        return nil
    }
}
