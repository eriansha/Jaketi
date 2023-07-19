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
            
                Text(estimateTimeInMinute <= 0 ? "Tiba di Peron" : "\(estimateTimeInMinute) menit")
                    .font(.title3)
            }
        }
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
