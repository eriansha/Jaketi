//
//  LocationService.swift
//  Jaketi
//
//  Created by Ivan on 22/07/23.
//

import Foundation
import CoreLocation
import UserNotifications

protocol LocationServiceDelegate: AnyObject {
    func requestAuthorization()
    func authorizationRestricted()
    func authorizationUknown()
    func promptAuthorizationAction()
    func didAuthorize()
    func didEntryRegion()
    func didExitRegion()
}


class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    weak var locationServiceDelegate: LocationServiceDelegate?
    
    private let locationManager = CLLocationManager()
    
    /** to detect distance change if move minimal certain meters */
    private let distanceFilter: Double = 8
    
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
    
    public func startMonitoring() {
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
            print("DEBUG: Location is not support to track circular region")
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
            print("LocationService DEBUG: denied")
            /** If user denied, we ask again until they accept */
            locationServiceDelegate?.promptAuthorizationAction()
            
        case .notDetermined:
            print("LocationService DEBUG: notDetermined")
            
        case .restricted:
            print("LocationService DEBUG: restricted")
            locationServiceDelegate?.authorizationRestricted()
            
        case .authorizedWhenInUse:
            print("LocationService DEBUG: authorizedWhenInUse")
            locationServiceDelegate?.didAuthorize()
            
        case .authorizedAlways:
            print("LocationService DEBUG: authorizedAlways")
            locationServiceDelegate?.didAuthorize()
            
        default:
            print("LocationService DEBUG: unknown")
            locationServiceDelegate?.authorizationUknown()
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
            
            if stationRegion.contains(location.coordinate) {
                
                if !isEnteredStation {
                    /**
                        trigger this delegate once user has been entered the station
                        e.g build location-notification and time-based notification
                     */
                    locationServiceDelegate?.didEntryRegion()
                    
                    /** set the flag so we can know the user has been entered the station once */
                    UserDefaults.standard.set(true, forKey: identifier)
                }
            } else {
                if isEnteredStation {
                    /**
                        trigger this delegate once user is left from the stations
                        e.g remove all notification from the queue
                     */
                    locationServiceDelegate?.didExitRegion()

                    /** set the flag so we can know the user left the station */
                    UserDefaults.standard.set(false, forKey: identifier)
                }
            }
        }
    }
}
