//
//  ScheduleRow.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

enum DestinationType {
    case bundaranHI
    case lebakBulus
    
    func getLabel() -> String {
        switch(self) {
        case .bundaranHI: return "Bundaran HI"
        case .lebakBulus: return "Lebak Bulus"
        }
    }
}

struct ScheduleRow: View {
    public var time: String
    public var destination: DestinationType
    public var stops: Int
    public var estimateTimeInMinute: Int
    
    private let isArrived: Bool
    
    init(time: String, destination: DestinationType, stops: Int, estimateTimeInMinute: Int) {
        self.time = time
        self.destination = destination
        self.stops = stops
        self.estimateTimeInMinute = estimateTimeInMinute
        
        self.isArrived = estimateTimeInMinute <= 0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Arah \(destination.getLabel())")
                    .font(.subheadline)
                
                Spacer()
                
                Text("\(stops) Perhentian")
                    .font(.subheadline)
            }
            
            HStack {
                Text(time)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
            
                Text(isArrived ? "Tiba di Peron" : "\(estimateTimeInMinute) menit")
                    .font(.title3)
            }
        }
        .padding()
        .cornerRadius(4.0)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isArrived ? .pink : .gray, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct ScheduleRow_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRow(
            time: "08:00",
            destination: DestinationType.bundaranHI,
            stops: 6,
            estimateTimeInMinute: 0
        )
    }
}
