//
//  AppDelegate.swift
//  Jaketi
//
//  Created by Priskilla Adriani on 21/07/23.
//

import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        return formatter
    }()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        sendForceCloseNotification()
//    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        sendForceCloseNotification()
    }
    
    func sendForceCloseNotification() {
        // let content = UNMutableNotificationContent()
//        content.title = "Lorem ipsum"
//        content.body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi suscipit mi nec orci dapibus rutrum."
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        NotificationTimeViewModel.shared.sendNotification()
    }
}
