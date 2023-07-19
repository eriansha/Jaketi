//
//  ScheduleList.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct ScheduleList: View {
    public var trainStation: TrainStation
    
    var body: some View {
        VStack {
            ForEach(trainStation.departureSchedules, id: \.self) { schedule in
                ScheduleRow(
                    timeDeparture: schedule.timeDeparture,
                    destination: schedule.destinationStation,
                    // TODO: uncomment once it's fixed
                    // stops: 6,
                    estimateTimeInMinute: 2
                )
            }
        }
    }
}

struct ScheduleList_Previews: PreviewProvider {
    static let departureSchedules: [TrainStation.DepartureSchedule] = [
        .init(
            timeDeparture: Date.now,
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now,
            destinationStation: DestinationType.lebakBulus,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now,
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        )
    ]
    
    static let trainStation: TrainStation = .init(
        stationId: 1,
        name: "Dukuh Atas",
        departureSchedules: departureSchedules
    )
    
    static var previews: some View {
        ScheduleList(trainStation: trainStation)
    }
}
