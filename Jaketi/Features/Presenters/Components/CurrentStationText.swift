//
//  CurrentStationText.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct CurrentStationText: View {
    var currentStation: TrainStation
    @Binding var presentSheet:Bool
    
    var body: some View {
        Button {
            presentSheet = true
        } label: {
            HStack{
                Image(systemName: "location.fill")
                    .foregroundColor(Theme.Colors.green)
                Text(String(currentStation.name).dropFirst(7))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
            }.padding()
                .background(.white)
            .cornerRadius(16)
        }.buttonStyle(.plain)
            
    }
}

struct CurrentStationText_Previews: PreviewProvider {
    static let trainStation: TrainStation = .init(
        stationId: 1,
        name: "Stasiun Dukuh Atas BNI",
        stationOrder: 11,
        departureSchedules: [],
        estimateDestinations: []
    )
    
    static var previews: some View {
        CurrentStationText(currentStation: trainStation, presentSheet: .constant(false))
            
    }
}
