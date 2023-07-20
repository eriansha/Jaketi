//
//  LiveScheduleView.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct LiveScheduleView: View {
    @EnvironmentObject var modelData: ModelData
    // TODO: change to user input
    private var destinationStation: DestinationType = .bundaranHI
    
    var body: some View {
        ScrollView {
            CurrentStationText()
            
            ScheduleList(
                trainStation: modelData.trainStations[11],
                destinationStation: destinationStation
            )
        }
    }
}

struct LiveScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LiveScheduleView()
            .environmentObject(ModelData())
    }
}
