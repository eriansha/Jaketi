//
//  AppConstant.swift
//  Jaketi
//
//  Created by Ivan on 23/07/23.
//

import Foundation

struct AppConstant {
    static let regionNotificationIdentifier: String = "info.jaketi.notification.region"
    static let scheduleNotificationIdentifier: String = "info.jaketi.notification.schedules"
}

// MARK: testing data
extension AppConstant {
    /** Use GOP 9 coordinate for prototyping purpose */
    struct testingCoordinate {
        static let latitude: Double = -6.302138383355241
        static let longitude: Double = 106.65226933626776
    }
}
