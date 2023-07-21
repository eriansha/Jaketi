//
//  NotificationViewModel.swift
//  Jaketi
//
//  Created by Eric Prasetya Sentosa on 20/07/23.
//

import Foundation
import CoreLocation
import UserNotifications
import UIKit

class NotificationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    let viewModel = TrainStationViewModel()
    let currentStation = ModelData().trainStations[11]
    let center = UNUserNotificationCenter.current()
    
    private var locationManager: CLLocationManager?
    // list station region to monitor
    private var geoFenceRegions: [CLCircularRegion] = [
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.20078175640807, longitude: 106.8228013473299), // (GOP)
            radius: 40,
            identifier: "Dukuh Atas BNI"),
        // DUKUH ATAS
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.20190, longitude: 106.822610), // station coordinate
            radius: 20,
            identifier: "Dukuh Atas BNI 1"),
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.20165, longitude: 106.822655), // station coordinate
            radius: 20,
            identifier: "Dukuh Atas BNI 2"),
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.20140, longitude: 106.822700), // station coordinate
            radius: 20,
            identifier: "Dukuh Atas BNI 3"),
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.20115, longitude: 106.822745), // station coordinate
            radius: 20,
            identifier: "Dukuh Atas BNI 4"),
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.20090, longitude: 106.822800), // station coordinate
            radius: 20,
            identifier: "Dukuh Atas BNI 5"),
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.20065, longitude: 106.822835), // station coordinate
            radius: 20,
            identifier: "Dukuh Atas BNI 6"),
    ]
    
    private func postNearestScheduleNotification(region: CLRegion) {
//        let viewModel = TrainStationViewModel()
//
//        // TODO: find currentStation using region.identifier
//        let currentStation = ModelData().trainStations[11] // dukuh atas bni
        
//        let departureSchedule = viewModel.filterDepartureSchedule(trainStation: currentStation)
        let departureSchedule = getCurrentSchedule()
        
        let nearestSchedule = departureSchedule.first!
        
        let title = nearestSchedule.destinationStation == .bundaranHI
            ? "Bundaran HI Train Arrival"
            : "Lebak Bulus Train Arrival"
        
        let timeDepartureString: String = convertDateToString(
            date: nearestSchedule.timeDeparture,
            format: "HH:mm"
        )
        
        let minutesInterval = Calendar.current.dateComponents([.minute], from: Date(), to: nearestSchedule.timeDeparture)
        
        postLocalNotifications(
            title: title,
            body: "Your train will arrive at \(timeDepartureString) (\(String(describing: minutesInterval.minute!)) minutes from now). Get ready on the platform. Safe journey!"
        )
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Update the map's center with the user's current location.
            if location.horizontalAccuracy <= 40 {
                var inRegion = false
                var getRegion = geoFenceRegions[0]
                for region in geoFenceRegions {
                    if region.contains(location.coordinate) {
                        inRegion = true
                        getRegion = region
                        break
                    } else {
                        inRegion = false
                        getRegion = region
                    }
                }
                
                let identifier = decodeIdentifier(regionIdentifier: getRegion.identifier)
                if inRegion {
                    //flag for user has entered that region or not
                    let hasEntered = UserDefaults.standard.bool(forKey: identifier)
                    if !hasEntered {
                        // USER ENTERED REGION
                        postNearestScheduleNotification(region: getRegion)
                        // TODO: post notif time-based
                        sendNotification()
                        UserDefaults.standard.set(true, forKey: identifier)
                    }
                } else {
                    let hasEntered = UserDefaults.standard.bool(forKey: identifier)
                    if hasEntered {
                        // TODO: remove time based notif
                        removeAllNotif()
                        UserDefaults.standard.set(false, forKey: identifier)
                    }
                }
            }
        }
    }

    
    func decodeIdentifier(regionIdentifier: String) -> String {
        if regionIdentifier.starts(with: "Dukuh Atas BNI") {
            return "Dukuh Atas BNI"
        }
        return regionIdentifier
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            initLocationManager()
        } else {
            print("location manager is off, user should turn it on")
        }
    }
    
    private func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager!.distanceFilter = 8 // to detect distance change if move minimal 8 meters
        locationManager!.allowsBackgroundLocationUpdates = true // for background notif
        locationManager!.startMonitoringSignificantLocationChanges()
        locationManager!.startUpdatingLocation()
        
        for region in geoFenceRegions {
            region.notifyOnExit = false
            region.notifyOnEntry = true
            locationManager!.startMonitoring(for: region)
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("your location is restricted")
        case .denied:
            print("your location is denied")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}

// NOTIFICATION FEATURE
extension NotificationViewModel {
    
    func requestPermissionNotifications(){
        let application =  UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            center.delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: authOptions) { (isAuthorized, error) in
                if( error != nil ){
                    print(error!)
                }
                else{
                    if( isAuthorized ){
                        print("authorized")
                        NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                    }
                    else{
                        let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                        if pushPreference == false {
                            let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        // Checking for setting is opened or not
                                        print("Setting is opened: \(success)")
                                    })
                                }
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                                print("user denied")
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            let viewController = UIApplication.shared.keyWindow!.rootViewController
                            DispatchQueue.main.async {
                                viewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }

    
    
    func postLocalNotifications(title: String, body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
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
}


// NOTIFICATION TIME-BASED FEATURE
extension NotificationViewModel {
    
    func getCurrentSchedule() -> [TrainStation.DepartureSchedule] {
        let currentDate = Date()
        
        var currentSchedules = {
            currentStation.departureSchedules.filter { schedule in
                return schedule.timeDeparture > currentDate && schedule.isWeekend == isWeekend()
            }
        }()
        
        currentSchedules = currentSchedules.sorted(by: {$0.timeDeparture < $1.timeDeparture})
        return currentSchedules
    }
    
    func sendNotification() {
        let currentSchedules = getCurrentSchedule()
        
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
}
