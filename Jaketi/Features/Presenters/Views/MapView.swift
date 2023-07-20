//
//  MapView.swift
//  Jaketi
//
//  Created by Eric Prasetya Sentosa on 20/07/23.
//


import UIKit
import MapKit
import CoreLocation
import UserNotifications

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    let circularRegion: CLCircularRegion

    init(circularRegion: CLCircularRegion) {
        self.circularRegion = circularRegion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestPermissionNotifications()
        
        // Initialize the MKMapView and set its delegate to self.
        mapView = MKMapView(frame: view.bounds)
        mapView.delegate = self
        view.addSubview(mapView)
        
        
        // Initialize and configure the location manager.
        checkIfLocationServicesIsEnabled()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 8
        locationManager.allowsBackgroundLocationUpdates = true
        circularRegion.notifyOnExit = true
        circularRegion.notifyOnEntry = true
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoring(for: circularRegion)
        print(circularRegion)

        // Call the function to add the circular region overlay.
        mapView.showsUserLocation = true
        addCircularRegionOverlay()
    }

    // Function to add the circular region overlay to the map.
    func addCircularRegionOverlay() {
        let circle = MKCircle(center: circularRegion.center, radius: circularRegion.radius)
        mapView.addOverlay(circle)
    }

    // MKMapViewDelegate function to render the overlay.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circleOverlay)
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.2)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    // CORE LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            // Update the map's center with the user's current location.
            if location.horizontalAccuracy <= 40 {
                mapView.setRegion( MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
                print(location)
            } else {
//                locationManager.startUpdatingLocation()
            }
//            print(locationManager.location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
        postLocalNotifications(eventTitle: "TEST Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
        postLocalNotifications(eventTitle: "TEST Exited: \(region.identifier)")
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("location manager is off, user should turn it on")
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
//            region = MKCoordinateRegion(center: locationManager.location!.coordinate,
//                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // NOTIFICATION
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

import SwiftUI

struct MapViewControllerWrapper: UIViewControllerRepresentable {
    let circularRegion: CLCircularRegion
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(circularRegion: circularRegion)
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        // You can add any updates here if needed.
    }
}
