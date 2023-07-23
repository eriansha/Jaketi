//
//  LiveScheduleView.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct LiveScheduleView: View {
    @EnvironmentObject var modelData: ModelData
    
    /** hardcoded default index as 11 that indicate Dukuh Atas Station */
    @State private var currentStationIndex: Int = 11
    @State private var selectedDestination: DestinationType = .bundaranHI
    @State private var presentSheet = false
    @State private var searchStationValue = ""
    private var viewModel = TrainStationViewModel()

    
    var body: some View {
        VStack{
            // TODO: Revine custom picker for current station
            CurrentStationText(
                currentStation: modelData.trainStations[currentStationIndex],
                presentSheet: $presentSheet
            )
            .padding()
            .background(Theme.Colors.blue)
            
            TrainBanner(destinationStation: selectedDestination, departureSchedules: viewModel.filterDepartureSchedule(
                trainStation: modelData.trainStations[currentStationIndex],
                destinationStation: selectedDestination,
                selectedDate: Date(),
                isWeekend: isWeekend())
            )
            
            // TODO: Revine custom picker for bound station
            BoundStationPicker(selectedDestination: $selectedDestination)
            
            ScrollView {
                ScheduleList(
                    trainStation: modelData.trainStations[currentStationIndex],
                    destinationStation: selectedDestination
                )
                
            }
        }.sheet(isPresented: $presentSheet) {
            SelectStationSheet(
                searchStationValue: $searchStationValue,
                presentSheet: $presentSheet,
                indexStation: $currentStationIndex
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
