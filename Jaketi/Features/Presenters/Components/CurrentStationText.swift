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
        VStack (alignment: .leading, spacing: 0) {
            Text(Theme.Title.schedule)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Button {
                presentSheet = true
            } label: {
                HStack{
                    Image(systemName: "location.fill")
                        .foregroundColor(Theme.Colors.green)
                    Text(String(currentStation.name).dropFirst(7))
                        .foregroundColor(Theme.Colors.highlightedLabel)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.gray)
                }.padding()
                    .background(Theme.Colors.card)
                .cornerRadius(16)
            }.buttonStyle(.plain)
        }
            
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
