//
//  UserNotificationManager.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/11/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit
import UserNotifications


class UserNotificationManager: NSObject {
    
    static let identifier = "ArrivalNotification"
 
    func sendNotification(title: String,
                          subtitle: String,
                          body: String,
                          badge: Int?,
                          delayInterval: Int?) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        var trigger: UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
        }
        
        if let badge = badge {
            var currentBadgeBount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeBount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeBount)
        }
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: UserNotificationManager.identifier, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension UserNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
        case UNNotificationDefaultActionIdentifier:
            print("The user opened the app from the notification")
        case UNNotificationDismissActionIdentifier:
            print("The user dismiss the notification")
        default:
            print("The default case was called")

        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
    }
}
