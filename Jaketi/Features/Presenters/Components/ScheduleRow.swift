//
//  ScheduleRow.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI


struct ScheduleRow: View {
    private var viewmodel = TrainStationViewModel()
    
    public var stationOrder: Int
    public var timeDeparture: Date
    public var destination: DestinationType
    // TODO: uncomment once it's fixed
    // public var stops: Int
    public var estimateDestinations: [TrainStation.EstimateDestinations]
    
    private var estimateTimeInMinute: Int = 0
    private let isArrived: Bool
    
    init(stationOrder:Int, timeDeparture: Date, destination: DestinationType, estimateDestinations: [TrainStation.EstimateDestinations]) {
        let viewModel = TrainStationViewModel()
        
        self.stationOrder = stationOrder
        self.timeDeparture = timeDeparture
        self.destination = destination
        // TODO: uncomment once it's fixed
        // self.stops = stops
        self.estimateTimeInMinute = viewModel.getTimeDifferenceInMinute(timeDeparture)
        self.isArrived = estimateTimeInMinute <= 0
        self.estimateDestinations = viewModel.filterEstimateDestination(stationOrder: stationOrder, estimateDestinations: estimateDestinations, destinationStation: destination)
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(
                content: {
                    VStack(spacing: 0) {
                        ForEach(estimateDestinations, id: \.self) { dest in
                            VStack(spacing: 0) {
                                HStack {
                                    VerticalLine()
                                        .stroke(Theme.Colors.line, lineWidth: 4)
                                        .frame(width: 20, height: 20)
                                    Spacer()
                                }
                                HStack {
                                    Circle()
                                        .strokeBorder(Theme.Colors.MRTGreen,lineWidth: 4)
                                        .frame(width: 20, height: 20)
                                    Text("\(dest.stationName)")
                                    Spacer()
                                    Text(timeDeparture.addingTimeInterval(TimeInterval(dest.travelTime * 60)), style: .time)
                                }
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Estimated arrival at \(dest.stationName) at \(timeDeparture.addingTimeInterval(TimeInterval(dest.travelTime * 60)), style: .time)")
                        }
                    }.padding(.bottom, 10)
                },
                label: {
                    VStack{
                        HStack{
                            Text(timeDeparture, style: .time)
                                .font(.largeTitle)
                                .foregroundColor(Theme.Colors.highlightedLabel)
                            
                            Spacer()
                            if(!isArrived){
                                Image(systemName: "hourglass")
                                    .foregroundColor(Theme.Colors.green)
                            }
                            Text(isArrived ? Theme.Strings.tibaDiPeron : "\(estimateTimeInMinute) \(Theme.Strings.menit)")
                                .font(.title2)
                                .foregroundColor(isArrived ? Theme.Colors.orange :Theme.Colors.green)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(isArrived ? "The train heading to \(destination.getLabel()) is already at platform, please hurry" : "The train heading to \(destination.getLabel()) will arrive at \(timeDeparture, style: .time), \(estimateTimeInMinute) minutes away")
                }
            ).accentColor(Theme.Colors.highlightedLabel)
        }
    }
}

struct ScheduleRow_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRow(
            stationOrder: 12,
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(70)),
            destination: DestinationType.bundaranHI,
            // TODO: uncomment once it's fixed
            // stops: 6,
            estimateDestinations: []
        )
    }
}
