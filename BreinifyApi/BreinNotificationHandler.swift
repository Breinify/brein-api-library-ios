//
// Created by Marco on 21.04.17.
//

import Foundation
import UserNotifications

open class BreinNotificationHandler {

    /// Initializer with "nothing"
    public init() {
    }

    @available(iOS 10.0, *)
    open func willPresent(_ notification: UNNotification) {
        
        print("BreinNotificationHandler willPresent called - received notification is: \(notification)")

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
                print(alert)
                message = alert
            }
        }
        
        let refreshAlert = UIAlertController(title: "Breinify Notification",
                message: message,
                preferredStyle: UIAlertControllerStyle.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
    }
    
    @available(iOS 10.0, *)
    open func didReceive(_ response: UNNotificationResponse) {

        print("BreinNotificationHandler didReceive calld - received response is: \(response)")
        
    }

    public func showDialog() {

        // print("BreinifyManager - received notification is: \(notification)")
        /*
        print(userInfo)
        var message = "The message"

        let image = userInfo["image"] as? String

        if let aps = userInfo["aps"] as? NSDictionary {
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

       let refreshAlert = UIAlertController(title: "Breinify Notification",
                message: message,
                preferredStyle: UIAlertControllerStyle.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        */
        
    }
    
}