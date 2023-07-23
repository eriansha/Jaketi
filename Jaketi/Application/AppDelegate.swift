//
//  AppDelegate.swift
//  Jaketi
//
//  Created by Priskilla Adriani on 21/07/23.
//

import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // sendForceCloseNotification()
        return true
    }
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        sendForceCloseNotification()
//    }
    
//    func sendForceCloseNotification() {
//        NotificationVM.requestPermissionNotifications()
//        NotificationVM.checkIfLocationServicesIsEnabled()
//    }
}
