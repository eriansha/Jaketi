//
//  DepartureScheduleViewModel.swift
//  Jaketi
//
//  Created by Ivan on 27/07/23.
//

import Foundation
import UserNotifications


class DepartureScheduleViewModel: ObservableObject {
    
    private var trainStationViewModel: TrainStationViewModel
    
    private var locationService: LocationService
    
    /** Maximum time-based notification queueing per session */
    private let maxScheduleNotification: Int = 5
    
    init() {
        self.trainStationViewModel = TrainStationViewModel()
        self.locationService = LocationService()
        locationService.locationServiceDelegate = self
        
        locationService.requestAuthorization()
    }
}

// MARK: Notification Builders
extension DepartureScheduleViewModel {
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
            identifier: AppConstant.regionNotificationIdentifier,
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
                identifier: "\(AppConstant.scheduleNotificationIdentifier).\(index)",
                content: content,
                trigger: trigger
            )
        }
    }
    
    func removeAllPendingNotificationRequest() {
        NotificationService.shared.removeAllPendingNotification()
    }
}

// MARK: Location Service Delegate
extension DepartureScheduleViewModel: LocationServiceDelegate {
    func requestAuthorization() {
        locationService.requestAuthorization()
    }
    
    func authorizationRestricted() {
        // TODO
    }
    
    func authorizationUknown() {
        // TODO
    }
    
    func promptAuthorizationAction() {
        // TODO
    }
    
    func didAuthorize() {
        locationService.startMonitoring()
    }
    
    func didEntryRegion() {
        triggerLocationBasedNotification()
        triggerTimeBasedNotification()
    }
    
    func didExitRegion() {
        removeAllPendingNotificationRequest()
    }
    
    
}
