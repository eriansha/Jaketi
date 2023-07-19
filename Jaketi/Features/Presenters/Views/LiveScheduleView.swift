//
//  LiveScheduleView.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct LiveScheduleView: View {
    private let trainStation: TrainStation = .init(
        name: "Dukuh Atas",
        schedules: [
            .init(time: "08:00"),
            .init(time: "08:05"),
            .init(time: "08:10"),
        ]
    )
    
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
