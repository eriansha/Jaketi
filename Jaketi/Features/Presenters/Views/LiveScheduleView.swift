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
    @State private var currentDate = Date()
    
    /** FIXME: workaroud to force scroll view rerender everytime call refreshData func */
    @State private var scrollViewUniqueId = UUID()
    
    private var viewModel = TrainStationViewModel()

    /** threshold time in second to refetch */
    private var thresholdRefetch: Double = 60
    
    /** Trigger to refresh list schedules every particular interval */
    private func refreshData() {
        Timer.scheduledTimer(withTimeInterval: thresholdRefetch, repeats: true) { _ in
            currentDate = Date()
            
            // force ScrollView to rerender every x time interval
            scrollViewUniqueId = UUID()
        }
    }
    
    private func filterSchedules() -> [TrainStation.DepartureSchedule] {
        return viewModel.filterDepartureSchedule(
            trainStation: modelData.trainStations[currentStationIndex],
            destinationStation: selectedDestination,
            selectedDate: currentDate,
            isWeekend: isWeekend()
        )
    }
    
    var body: some View {
        VStack {
            // TODO: Revine custom picker for current station
            CurrentStationText(
                currentStation: modelData.trainStations[currentStationIndex],
                presentSheet: $presentSheet
            )
            .padding()
            .background(Theme.Colors.blue)
            
            TrainBanner(
                destinationStation: selectedDestination,
                departureSchedules: filterSchedules()
            )
            
            // TODO: Revine custom picker for bound station
            BoundStationPicker(selectedDestination: $selectedDestination)
            
            ScrollView() {
                ScheduleList(
                    trainStation: modelData.trainStations[currentStationIndex],
                    departureSchedules: filterSchedules(),
                    destinationStation: selectedDestination
                )
            }.id(scrollViewUniqueId)
        }.sheet(isPresented: $presentSheet) {
            SelectStationSheet(
                searchStationValue: $searchStationValue,
                presentSheet: $presentSheet,
                indexStation: $currentStationIndex
            )
        }.onAppear {
            refreshData()
        }
    }
}

struct LiveScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LiveScheduleView()
            .environmentObject(ModelData())
    }
}
