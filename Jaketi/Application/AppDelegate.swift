//
//  AppDelegate.swift
//  Jaketi
//
//  Created by Priskilla Adriani on 21/07/23.
//

import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {
    let center = UNUserNotificationCenter.current()
    var modelData = ModelData()
    var currentSchedules: [TrainStation.DepartureSchedule]?
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        return formatter
    }()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        sendForceCloseNotification()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        sendForceCloseNotification()
    }
    
    func sendForceCloseNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
//        let userDefaults = UserDefaults.standard
//        if userDefaults.objectIsForced(forKey: "")
        sendNotification()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func getCurrentSchedule() {
        let currentDate = Date()
        let trainStation = modelData.trainStations[11]
        
        currentSchedules = {
            trainStation.departureSchedules.filter { schedule in
                return schedule.timeDeparture > currentDate && schedule.isWeekend == isWeekend()
            }
        }()
    }
    
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification() {
        requestPermission()
        getCurrentSchedule()
        guard let currentSchedules = currentSchedules else { return }
        
        for i in 0..<currentSchedules.count {
            let nextSchedule = currentSchedules[i]
            
            let timeNotif = nextSchedule.timeDeparture.adding(minutes: 1)
//            let timeNotif = Date().adding(minutes: 1)
            let dateComponentNotif = Calendar.current.dateComponents([.hour, .minute], from: timeNotif)
            
            let content = UNMutableNotificationContent()
            content.title = "Kereta menuju \(nextSchedule.destinationStation.getLabel())"
            content.body = "Kereta selanjutnya akan tiba pukul \(Date.timeFormatter.string(from: nextSchedule.timeDeparture))"
            content.sound = .default

            let notificationIdentifier = nextSchedule.id.uuidString
             let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentNotif, repeats: false)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    func removeAllNotif() {
        center.removeAllPendingNotificationRequests()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        sendNotification()
        print("masuk")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
    
}
