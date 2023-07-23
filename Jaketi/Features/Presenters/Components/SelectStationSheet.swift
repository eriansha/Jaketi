//
//  SelectStationSheet.swift
//  Jaketi
//
//  Created by Ivan on 23/07/23.
//

import SwiftUI

struct SelectStationSheet: View {
    @EnvironmentObject private var modelData: ModelData
    
    @Binding public var searchStationValue: String
    @Binding public var presentSheet: Bool
    @Binding public var indexStation: Int
    
    private let viewModel = TrainStationViewModel()
    
    func handleSelectStation(_ selectedStation: TrainStation) {
        indexStation = selectedStation.stationOrder - 1
        presentSheet.toggle()
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.filterSearchStation(
                trainStations: modelData.trainStations,
                searchValue: searchStationValue
            )) { station in
                
                Button {
                    handleSelectStation(station)
                } label: {
                    Text(String(station.name)
                        .dropFirst(7))
                    .padding(.horizontal)
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchStationValue, prompt: "Search Station")
            .navigationTitle("Station")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentSheet.toggle()
                    }
                }
            }
        }
    }
}

struct SelectStationSheet_Previews: PreviewProvider {    
    static var previews: some View {
        SelectStationSheet(
            searchStationValue: .constant(""),
            presentSheet: .constant(true),
            indexStation: .constant(0)
        ).environmentObject(ModelData())
    }
}
