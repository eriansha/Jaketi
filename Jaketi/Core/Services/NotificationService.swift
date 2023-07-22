//
//  NotificationService.swift
//  Jaketi
//
//  Created by Ivan on 22/07/23.
//

import Foundation
import NotificationCenter

class NotificationService {
    static let shared: NotificationService = NotificationService()
    
    private init() {}
    
    let center = UNUserNotificationCenter.current()
    
    func askPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            // Enable or disable features based on the authorization.
        }
    }
    
    // Delegate method to handle notification presentation while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Customize the presentation options as desired
        completionHandler([.banner, .list, .sound])
    }
    
    // Delegate method to handle user interaction with the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the user's response to the notification
        completionHandler()
    }
    
    func removeAllPendingNotification() {
        center.removeAllPendingNotificationRequests()
    }
    
    func sendInstantNotification(
        identifier: String,
        content: UNMutableNotificationContent,
        trigger: UNNotificationTrigger? = nil
    ) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
//        center.add(request) { (error) in
//            if let error = error {
//                print("Failed to sent notification:", error.localizedDescription)
//            }
//        }
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
    }
}
