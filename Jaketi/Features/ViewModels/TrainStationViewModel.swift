//
//  TrainStationViewModel.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import Foundation

class TrainStationViewModel {
    func mergeDepartureSchedule(
        scheduleLBWeekday: String,
        scheduleLBWeekend: String,
        scheduleHIWeekday: String,
        scheduleHIWeekend: String
    ) -> [TrainStation.DepartureSchedule] {
        let destinationLBWeekday = transformDepartureSchedule(
            schduleInString: scheduleLBWeekday,
            destinationStation: DestinationType.lebakBulus
        )
        let destinationLBWeekend = transformDepartureSchedule(
            schduleInString: scheduleLBWeekend,
            destinationStation: DestinationType.lebakBulus,
            isWeekend: true
        )
        
        let destinationHIWeekday = transformDepartureSchedule(
            schduleInString: scheduleHIWeekday,
            destinationStation: DestinationType.bundaranHI
        )
        let destinationHIWeekend = transformDepartureSchedule(
            schduleInString: scheduleHIWeekend,
            destinationStation: DestinationType.bundaranHI,
            isWeekend: true
        )
        
        var mergedTimeDeparture: [TrainStation.DepartureSchedule] {
            return destinationLBWeekday + destinationLBWeekend + destinationHIWeekday + destinationHIWeekend
        }
        
        return mergedTimeDeparture
    }
    
    func transformDepartureSchedule(
        schduleInString: String,
        destinationStation: DestinationType,
        isWeekend: Bool = false
    ) -> [TrainStation.DepartureSchedule] {
        let formatter = DateFormatter()
        let schedules = schduleInString.split(separator: ",")
        var timeDepartures: [TrainStation.DepartureSchedule] = []
        
        
        var currentDateString: String = convertDateToString(
            date: Date(),
            format: "yyyy-MM-dd"
        )
        
        schedules.forEach { scheduleTimeString in
            if let parsedTimeDeparture = convertStringToDate(
                dateString: "\(currentDateString)\(scheduleTimeString)",
                format: "yyyy-MM-dd HH:mm"
            ) {
             
                print(parsedTimeDeparture)
                let obj = TrainStation.DepartureSchedule.init(
                    timeDeparture: parsedTimeDeparture,
                    destinationStation: destinationStation,
                    isWeekend: isWeekend
                )
                
                timeDepartures.append(obj)
            }
        }
        
        return timeDepartures
    }
}
