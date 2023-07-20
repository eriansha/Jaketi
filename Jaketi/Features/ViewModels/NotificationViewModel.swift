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
    
    private var locationManager: CLLocationManager?
    // list station region to monitor
    private var geoFenceRegions: [CLCircularRegion] = [
        CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: -6.302358, longitude: 106.65224), // station coordinate (default GOP)
            radius: 40,
            identifier: "Lebak Bulus Station"),
        
    ]
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
        postLocalNotifications(eventTitle: "Jaketi Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
        postLocalNotifications(eventTitle: "Jaketi Exited: \(region.identifier)")
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
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
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

    
    
    func postLocalNotifications(eventTitle:String){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "You've entered a new region"
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
        completionHandler([.alert, .sound])
    }
    
    // Delegate method to handle user interaction with the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the user's response to the notification
        completionHandler()
    }
}
