//
//  LocationService.swift
//  Jaketi
//
//  Created by Ivan on 22/07/23.
//

import Foundation
import CoreLocation
import UserNotifications


class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    /** to detect distance change if move minimal certain meters */
    private let distanceFilter: Double = 8
    
    /** Maximum time-based notification queueing per session */
    private let maxScheduleNotification: Int = 5
    
    private let trainStationViewModel = TrainStationViewModel()
    
    /** list station region to monitor **/
    private var stationRegions: [CLCircularRegion] = [
        CLCircularRegion(
            center: CLLocationCoordinate2D(
                latitude: AppConstant.testingCoordinate.latitude,
                longitude: AppConstant.testingCoordinate.longitude
            ),
            radius: 20,
            identifier: "Dukuh Atas BNI"),
    ]
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = distanceFilter
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    private func startMonitoring() {
        /** Make sure the devices supports region monitoring. */
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            /** Start monitoring every registred regions */
            for region in stationRegions {
                region.notifyOnExit = true
                region.notifyOnEntry = true
                locationManager.startMonitoring(for: region)
            }
        } else {
            // TODO: send kind of alert to inform user
            print("Location is not support to track circular region")
        }
    }
    
    public func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
    }
}

// MARK: Core Location Delegate
extension LocationService {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        switch status {
        case .denied:
            print("denied")
            // TODO: ask user to authorize
            
        case .notDetermined:
            print("notDetermined")
            
        case .restricted:
            print("restricted")
            //TODO: inform the user
            
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            startMonitoring()
            
        case .authorizedAlways:
            print("authorizedAlways")
            startMonitoring()
            
        default:
            print("unknown")
            // TODO: inform the user
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle the location updates here
        // You can trigger local notifications when the user enters a specific region or based on any other location criteria.
        
        guard let location = locations.last else {
            return
        }
        
        guard location.horizontalAccuracy <= 40 else {
            return
        }
        
        for stationRegion in stationRegions {
            
            let identifier = stationRegion.identifier
            let isEnteredStation = UserDefaults.standard.bool(forKey: identifier)
            
            print("current location: \(location.coordinate)")
            
            if stationRegion.contains(location.coordinate) {
                
                if !isEnteredStation {
                    /**
                     If the user has been entered the station, we would like to trigger notication once
                     since we don't want to spam them
                     */
                    triggerLocationBasedNotification()
                    
                    /** Build time-based notification based on available schedule */
                    triggerTimeBasedNotification()
                    
                    /** set the flag so we can know the user has been entered the station once */
                    UserDefaults.standard.set(true, forKey: identifier)
                }
            } else {
                if isEnteredStation {
                    /** If the user left from the stations, we will remove all notification from the queue */
                    removeAllPendingNotificationRequest()

                    /** set the flag so we can know the user left the station */
                    UserDefaults.standard.set(false, forKey: identifier)
                }
            }
        }
    }
}

// MARK: Notification Builders
// TODO: we would like to separate the use case with the location service
extension LocationService {
    func triggerLocationBasedNotification() {
        /** Preprare the data before create Notification content */
        // TODO: change to get station dynamically (no hardcode)
        let currentStation = ModelData().trainStations[11]
        let currentDate = Date()
        
        let departureSchedules = trainStationViewModel.filterDepartureSchedule(
            trainStation: currentStation,
            selectedDate: currentDate,
            isWeekend: isWeekend()
        )
        
        /** guard in case the filter result did not return any schedules */
        guard departureSchedules.count > 0 else { return }
        
        let nearestSchedule = departureSchedules.first!
        let timeDepartureString: String = convertDateToString(
            date: nearestSchedule.timeDeparture,
            format: "HH:mm"
        )
        let minutesInterval = Calendar.current.dateComponents([.minute], from: Date(), to: nearestSchedule.timeDeparture)
        
        /** setup notification content. including: title, body, sound */
        let content = UNMutableNotificationContent()
        content.title = "\(nearestSchedule.destinationStation.getLabel()) Train Arrival"
        content.body = "Your train will arrive at \(timeDepartureString) (\(String(describing: minutesInterval.minute!)) minutes from now). Get ready on the platform. Safe journey!"
        content.sound = UNNotificationSound.default
        
        /** Setup notification trigger */
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )
        
        NotificationService.shared.sendInstantNotification(
            identifier: "info.jaketi.notification.region",
            content: content,
            trigger: trigger
        )
    }
    
    func triggerTimeBasedNotification() {
        /** Preprare the data before create Notification content */
        // TODO: change to get station dynamically (no hardcode)
        let currentStation = ModelData().trainStations[11]
        let currentDate = Date()
        
        let currentSchedules = trainStationViewModel.filterDepartureSchedule(
            trainStation: currentStation,
            selectedDate: currentDate,
            isWeekend: isWeekend()
        )
        
        for index in 0..<currentSchedules.count {
            
            /** FIXME: workaround to display first x train schedules to prevent Notification request out of limit (max 64).*/
            if index > maxScheduleNotification {
                break;
            }
            
            let nextSchedule = currentSchedules[index]
            
            /** set the nofication earlier so the passanger don't miss the train */
            let earlierNotificationTime = nextSchedule.timeDeparture.adding(minutes: 1)
            let dateComponent = Calendar.current.dateComponents(
                [.hour, .minute], from: earlierNotificationTime
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponent,
                repeats: false
            )

            /** setup notification content. including: title, body, sound */
            let content = UNMutableNotificationContent()
            content.title = "\(nextSchedule.destinationStation.getLabel()) Train Leave"
            content.body = "The next train will be arrived at \(Date.timeFormatter.string(from: nextSchedule.timeDeparture))"
            content.sound = .default

            NotificationService.shared.sendInstantNotification(
                identifier: "info.jaketi.notification.schedules.\(index)",
                content: content,
                trigger: trigger
            )
        }
    }
    
    func removeAllPendingNotificationRequest() {
        NotificationService.shared.removeAllPendingNotification()
    }
}
