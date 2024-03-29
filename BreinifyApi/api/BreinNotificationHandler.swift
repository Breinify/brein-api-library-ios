//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation
import UserNotifications

open class BreinNotificationHandler : NSObject {

    /// Initializer with "nothing"
    override
    public init() {
    }

    @available(iOS 10.0, *)
    open func willPresent(_ notification: UNNotification) {
        BreinLogger.shared.log("Breinify willPresent called - received notification is: \(notification)")

        var message = "The message"

        let userInfo = notification.request.content.userInfo

        // let image = userInfo["image"] as? String

        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let msg = alert["message"] as? String {
                    message = msg
                }
            } else if let alert = aps["alert"] as? String {
                //Do stuff
                BreinLogger.shared.log(alert)
                message = alert
            }
        }

        let refreshAlert = UIAlertController(title: "Breinify Notification",
                message: message,
                preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            BreinLogger.shared.log("Breinify Ok logic here")
        }))
    }

    @available(iOS 10.0, *)
    open func didReceive(_ response: UNNotificationResponse) {
        BreinLogger.shared.log("Breinify didReceive called - received response is: \(response)")
    }

}
