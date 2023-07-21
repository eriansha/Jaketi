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
        scheduleLBWeekday: String?,
        scheduleLBWeekend: String?,
        scheduleHIWeekday: String?,
        scheduleHIWeekend: String?
    ) -> [TrainStation.DepartureSchedule] {
        var destinationLBWeekday: [TrainStation.DepartureSchedule] = []
        var destinationLBWeekend: [TrainStation.DepartureSchedule] = []
        var destinationHIWeekday: [TrainStation.DepartureSchedule] = []
        var destinationHIWeekend: [TrainStation.DepartureSchedule] = []
        
        if let scheduleString = scheduleLBWeekday {
            destinationLBWeekday = transformDepartureSchedule(
                schduleInString: scheduleString,
                destinationStation: DestinationType.lebakBulus
            )
        }
        
        if let scheduleString = scheduleLBWeekend {
            destinationLBWeekend = transformDepartureSchedule(
                schduleInString: scheduleString,
                destinationStation: DestinationType.lebakBulus,
                isWeekend: true
            )
        }
        
        if let scheduleString = scheduleHIWeekday {
            destinationHIWeekday = transformDepartureSchedule(
                schduleInString: scheduleString,
                destinationStation: DestinationType.bundaranHI
            )
        }
        
        if let scheduleString = scheduleHIWeekend {
            destinationHIWeekend = transformDepartureSchedule(
                schduleInString: scheduleString,
                destinationStation: DestinationType.bundaranHI,
                isWeekend: true
            )
        }
        
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
    
    func getTimeDifferenceInMinute(_ anotherDate: Date) -> Int {
        let currentDate = Date()
        let timeInterval = anotherDate.timeIntervalSince(currentDate)
        
        let minuteDifference = Int(timeInterval / 60)
        return minuteDifference
    }
    
    func filterDepartureSchedule(
        trainStation: TrainStation,
        destinationStation: DestinationType,
        selectedDate: Date,
        isWeekend: Bool
    ) -> [TrainStation.DepartureSchedule] {
        /** Filtering departure schedule based on certain criteria */
        var filteredDepartureSchedules: [TrainStation.DepartureSchedule] {
            trainStation.departureSchedules.filter { schedule in
                return schedule.timeDeparture > selectedDate
                    && schedule.isWeekend == isWeekend
                    && schedule.destinationStation == destinationStation
            }
        }
        
        /** limiting the filter result by 3 items. if the total of data is less than threshold, we display as it is */
        let limitedFilteredSchedules = filteredDepartureSchedules.count > 4
            ? Array(filteredDepartureSchedules[0...3])
            : filteredDepartureSchedules
        
        return limitedFilteredSchedules
    }
}
