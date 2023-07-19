//
//  LiveScheduleView.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct LiveScheduleView: View {
    private let trainStation: TrainStation
    
    init() {
        self.trainStation = .init(
            name: "Dukuh Atas",
            departureSchedules: [
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
        )
    }
    
    var body: some View {
        ScrollView {
            CurrentStationText()
            
            ScheduleList(trainStation: trainStation)
        }
    }
}

struct LiveScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LiveScheduleView()
    }
}
