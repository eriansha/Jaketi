//
//  NotificationTimeViewModel.swift
//  Jaketi
//
//  Created by Priskilla Adriani on 20/07/23.
//

import Foundation
import UserNotifications

class NotificationTimeViewModel: NSObject, UNUserNotificationCenterDelegate {
    static let shared: NotificationTimeViewModel = NotificationTimeViewModel()
    
    let center = UNUserNotificationCenter.current()
    var modelData = ModelData()
    var currentSchedule: TrainStation.DepartureSchedule?
    var nextSchedule: TrainStation.DepartureSchedule?
    
    override init() {
        super.init()
        
        center.delegate = self
        requestPermission()
    }
    
    func getCurrentSchedule() {
        let currentDate = Date()
        let trainStation = modelData.trainStations[11]
        
        let currentSchedules = {
            trainStation.departureSchedules.filter { schedule in
                return schedule.timeDeparture > currentDate && schedule.isWeekend == isWeekend()
            }
        }()
        
        currentSchedule = currentSchedules.first
        nextSchedule = currentSchedules[1]
        print("curr : \(String(describing: currentSchedule)) last : \(String(describing: nextSchedule))")
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
        
        guard let nextSchedule = nextSchedule else { return }
//        guard let timeNotif = currentSchedule?.timeDeparture.adding(minutes: 1) else { return }
        let timeNotif = Date().adding(minutes: 1)
        let dateComponentNotif = Calendar.current.dateComponents([.hour, .minute], from: timeNotif)
        
        let content = UNMutableNotificationContent()
        content.title = "Kereta menuju \(currentSchedule?.destinationStation.getLabel() ?? "")"
        content.body = "Kereta selanjutnya akan tiba pukul \(Date.timeFormatter.string(from: nextSchedule.timeDeparture))"
        content.sound = .default

        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentNotif, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request)
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
