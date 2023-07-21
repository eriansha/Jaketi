//
//  LiveScheduleView.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct LiveScheduleView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedDestination: DestinationType = .bundaranHI
    
    var body: some View {
        VStack{
            // TODO: Revine custom picker for current station
            CurrentStationText()
            
            TrainBanner(trainStation: modelData.trainStations[11], destinationStation: selectedDestination)
            
            // TODO: Revine custom picker for bound station
            BoundStationPicker(selectedDestination: $selectedDestination)
            
            ScrollView {
                ScheduleList(
                    trainStation: modelData.trainStations[11],
                    destinationStation: selectedDestination
                )
                
            }
        }
    }
}

struct LiveScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LiveScheduleView()
            .environmentObject(ModelData())
    }
}
