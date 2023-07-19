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
            ForEach(trainStation.schedules, id: \.self) { schedule in
                ScheduleRow(
                    time: schedule.time,
                    destination: DestinationType.bundaranHI,
                    stops: 6,
                    estimateTimeInMinute: 0
                )
            }
        }
    }
}

struct ScheduleList_Previews: PreviewProvider {
    static let trainStation: TrainStation = .init(
        name: "Dukuh Atas",
        schedules: [
            .init(time: "08:00"),
            .init(time: "08:05"),
            .init(time: "08:10"),
        ]
    )
    
    static var previews: some View {
        ScheduleList(trainStation: trainStation)
    }
}
