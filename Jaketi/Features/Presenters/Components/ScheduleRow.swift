//
//  ScheduleRow.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI


struct ScheduleRow: View {
    public var timeDeparture: Date
    public var destination: DestinationType
    // TODO: uncomment once it's fixed
    // public var stops: Int
    public var estimateTimeInMinute: Int
    
    private let isArrived: Bool
    
    init(timeDeparture: Date, destination: DestinationType, estimateTimeInMinute: Int) {
        self.timeDeparture = timeDeparture
        self.destination = destination
        // TODO: uncomment once it's fixed
        // self.stops = stops
        self.estimateTimeInMinute = estimateTimeInMinute
        
        self.isArrived = estimateTimeInMinute <= 0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Arah \(destination.getLabel())")
                    .font(.subheadline)
                
                Spacer()
                
                // TODO: uncomment once it's fixed
                // Text("\(stops) Perhentian")
                //    .font(.subheadline)
            }
            
            HStack {
                Text(timeDeparture, style: .time)
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
            timeDeparture: Date.now,
            destination: DestinationType.bundaranHI,
            // TODO: uncomment once it's fixed
            // stops: 6,
            estimateTimeInMinute: 1
        )
    }
}
