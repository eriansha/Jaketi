//
//  TrainStationViewModel.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import Foundation

class TrainStationViewModel {
    /** merged decoded schedule into single data-type */
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
    
    /** parse string-based schedule into Model */
    func transformDepartureSchedule(
        schduleInString: String,
        destinationStation: DestinationType,
        isWeekend: Bool = false
    ) -> [TrainStation.DepartureSchedule] {
        let schedules = schduleInString.split(separator: ",")
        var timeDepartures: [TrainStation.DepartureSchedule] = []
        
        
        let currentDateString: String = convertDateToString(
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
    
    func filterDepartureSchedule(trainStation: TrainStation) -> [TrainStation.DepartureSchedule] {
        let currentDate = Date()
        
        var filteredDepartureSchedules: [TrainStation.DepartureSchedule] {
            trainStation.departureSchedules.filter { schedule in
                return schedule.timeDeparture > currentDate && schedule.isWeekend == isWeekend()
            }
        }
        
        let limitedFilteredSchedules = Array(filteredDepartureSchedules[0...3])
        return limitedFilteredSchedules
    }
}
