//
//  NotificationViewModel.swift
//  Jaketi
//
//  Created by Eric Prasetya Sentosa on 20/07/23.
//

import Foundation
import CoreLocation

class NotificationViewModel: ObservableObject {
    
    @Published var geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.302358, longitude: 106.65224), radius: 40, identifier: "GOP")
}
