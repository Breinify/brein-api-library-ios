//
// Created by Marco on 12/30/20.
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation
import UserNotifications

@available(iOS 10.0, *)
open class BreinNotificationServiceExtension: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var receivedRequest: UNNotificationRequest!

    open override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        receivedRequest = request
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            Breinify.didReceiveNotificationExtensionRequest(receivedRequest as Any, bestAttemptContent: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }

    open override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            Breinify.serviceExtensionTimeWillExpire(bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }

}