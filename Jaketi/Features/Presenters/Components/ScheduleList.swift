//
//  ScheduleList.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct ScheduleList: View {
    public var trainStation: TrainStation
    public var destinationStation: DestinationType
    private var departureSchedules: [TrainStation.DepartureSchedule]
    
    init(trainStation: TrainStation, destinationStation: DestinationType) {
        let currentDate = Date()
        let viewModel = TrainStationViewModel()
        
        self.trainStation = trainStation
        self.destinationStation = destinationStation
        self.departureSchedules = viewModel.filterDepartureSchedule(
            trainStation: trainStation,
            destinationStation: destinationStation,
            selectedDate: currentDate,
            isWeekend: isWeekend()
        )
    }
    
    var body: some View {
        VStack {
            if departureSchedules.count > 0 {
                ForEach(departureSchedules, id: \.self) { schedule in
                    ScheduleRow(
                        timeDeparture: schedule.timeDeparture,
                        destination: schedule.destinationStation
                        // TODO: uncomment once it's fixed
                        // stops: 6
                    )
                }
            } else {
                Text("No schedule in this station")
            }
        }
    }
}

struct ScheduleList_Previews: PreviewProvider {
    
    static let departureSchedules: [TrainStation.DepartureSchedule] = [
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
        departureSchedules: departureSchedules
    )
    
    static var previews: some View {
        ScheduleList(
            trainStation: trainStation,
            destinationStation: .bundaranHI
        )
    }
}
