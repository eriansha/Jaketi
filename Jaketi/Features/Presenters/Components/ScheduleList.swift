//
//  ScheduleList.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct ScheduleList: View {
    public var trainStation: TrainStation
    public var departureSchedules: [TrainStation.DepartureSchedule]
    public var destinationStation: DestinationType
    
    init(
        trainStation: TrainStation,
        departureSchedules: [TrainStation.DepartureSchedule],
        destinationStation: DestinationType
    ) {
        self.trainStation = trainStation
        self.departureSchedules = departureSchedules
        self.destinationStation = destinationStation
    }
    
    var body: some View {
        VStack {
            if departureSchedules.count > 0 {
                ForEach(departureSchedules, id: \.self) { schedule in
                    ScheduleRow(
                        stationOrder: trainStation.stationOrder,
                        timeDeparture: schedule.timeDeparture,
                        destination: schedule.destinationStation,
                        // TODO: uncomment once it's fixed
                        // stops: 6
                        estimateDestinations: trainStation.estimateDestinations
                    )
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(.white)
                    .cornerRadius(10)
                }
            } else {
                Text("No schedule")
            }
        }.padding(.horizontal)
    }
}

struct ScheduleList_Previews: PreviewProvider {
    
    static let departureSchedules: [TrainStation.DepartureSchedule] = [
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(60)),
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(2 * 60)),
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(3 * 60)),
            destinationStation: DestinationType.lebakBulus,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(4 * 60)),
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        )
    ]
    
    static let trainStation: TrainStation = .init(
        stationId: 1,
        name: "Dukuh Atas",
        stationOrder: 11,
        departureSchedules: departureSchedules,
        estimateDestinations: []
    )
    
    static var previews: some View {
        ScheduleList(
            trainStation: trainStation,
            departureSchedules: trainStation.departureSchedules,
            destinationStation: .bundaranHI
        )
    }
}
