//
//  LiveScheduleView.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct LiveScheduleView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var currentStation: Int = 0
    @State private var selectedDestination: DestinationType = .bundaranHI
    @State private var presentSheet = false
    @State private var searchStationValue = ""
    private var viewModel = TrainStationViewModel()

    
    var body: some View {
        VStack{
            // TODO: Revine custom picker for current station
            CurrentStationText(currentStation: modelData.trainStations[currentStation], presentSheet: $presentSheet)
                .padding()
                .background(Theme.Colors.primary)
            
            TrainBanner(destinationStation: selectedDestination, departureSchedules: viewModel.filterDepartureSchedule(
                trainStation: modelData.trainStations[currentStation],
                destinationStation: selectedDestination,
                selectedDate: Date(),
                isWeekend: isWeekend())
            )
            
            // TODO: Revine custom picker for bound station
            BoundStationPicker(selectedDestination: $selectedDestination)
            
            ScrollView {
                ScheduleList(
                    trainStation: modelData.trainStations[currentStation],
                    destinationStation: selectedDestination
                )
                
            }
        }.sheet(isPresented: $presentSheet) {
            NavigationStack {
                    List(viewModel.filterSearchStation(trainStations: modelData.trainStations, searchValue: searchStationValue)) {
                         station in
                            
                            Button{
                                currentStation = station.stationOrder-1
                                presentSheet = false
                            }label: {
                                Text(String(modelData.trainStations[station.stationOrder-1].name).dropFirst(7))
                                    .padding(.horizontal)
                            }
                        
                    }.listStyle(.plain)
                    .navigationTitle("Station")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                presentSheet = false
                            }
                        }
                    }
                    .searchable(text: $searchStationValue, prompt: "Search Station")
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
