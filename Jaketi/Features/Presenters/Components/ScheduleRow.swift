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
    
    private var estimateTimeInMinute: Int = 0
    private let isArrived: Bool
    
    init(timeDeparture: Date, destination: DestinationType) {
        let viewModel = TrainStationViewModel()
        
        self.timeDeparture = timeDeparture
        self.destination = destination
        // TODO: uncomment once it's fixed
        // self.stops = stops
        self.estimateTimeInMinute = viewModel.getTimeDifferenceInMinute(timeDeparture)
        self.isArrived = estimateTimeInMinute <= 0
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(
                content: {
                    VStack(spacing: 0) {
                        ForEach((1...5), id: \.self) {_ in
                            VStack(spacing: 0) {
                                HStack {
                                    VerticalLine()
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width: 16, height: 20)
                                    Spacer()
                                }
                                HStack {
                                    Circle()
                                        .strokeBorder(Theme.Colors.blue,lineWidth: 2)
                                        .frame(width: 16, height: 16)
                                    Text("Dukuh Atas")
                                    Spacer()
                                }
                            }
                        }
                    }
                },
                label: {
                    VStack{
                        HStack{
                            Text("Arah \(destination.getLabel())")
                                .font(.subheadline)
                                .foregroundColor(Theme.Colors.blue)
                            Spacer()
                        }
                        HStack{
                            Text(timeDeparture, style: .time)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.Colors.blue)
                            
                            Spacer()
                        
                            Text(isArrived ? "Tiba di Peron" : "\(estimateTimeInMinute) menit")
                                .font(.title3)
                                .foregroundColor(Theme.Colors.blue)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(isArrived ? "Kereta dengan arah \(destination.getLabel()) sudah berada di Peron, harap bergegas" : "Kereta dengan arah \(destination.getLabel()) akan tiba di pukul \(timeDeparture, style: .time), \(estimateTimeInMinute) menit lagi")
                }
            ).accentColor(Theme.Colors.blue)
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
            destination: DestinationType.bundaranHI
            // TODO: uncomment once it's fixed
            // stops: 6,
        )
    }
}
