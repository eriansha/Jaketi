//
//  NearestTrain.swift
//  Jaketi
//
//  Created by Hilmy Noerfatih on 21/07/23.
//

import SwiftUI

struct TrainBanner: View {
    @State private var isTextVisible = true
    
    public var trainStation: TrainStation
    public var destinationStation: DestinationType
    private var departureSchedules: TrainStation.DepartureSchedule
    private var estimateTimeInMinute: Int = 0
    private let isArrived: Bool
    
    init(trainStation: TrainStation, destinationStation: DestinationType) {
        let currentDate = Date()
        let viewModel = TrainStationViewModel()
        
        self.trainStation = trainStation
        self.destinationStation = destinationStation
        self.departureSchedules = viewModel.filterDepartureSchedule(
            trainStation: trainStation,
            destinationStation: destinationStation,
            selectedDate: currentDate,
            isWeekend: isWeekend()
        )[0]
        self.estimateTimeInMinute = viewModel.getTimeDifferenceInMinute(departureSchedules.timeDeparture)
        self.isArrived = estimateTimeInMinute <= 0
    }
    
    var body: some View {
        VStack {
            ZStack{
                Image("Banner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 16)
                HStack {
                    Spacer()
                    VStack{
                        HStack {
                            Spacer()
                            HStack {
                                Image(systemName:"train.side.front.car").foregroundColor(.white)
                                Text("Bound for \(destinationStation.getLabel())")
                                    .foregroundColor(Color.white)
                            }
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Theme.Colors.green)
                            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                        }
                        
                        
                        HStack {
                            Spacer()
                            Text(isArrived ? "Arrived at platform": "Arriving in \(estimateTimeInMinute) Minutes")
                                .font(.title3)
                                .bold()
                                .padding(.horizontal, 10)
                                .opacity(isTextVisible ? 1.0 : 0.1)
//                                .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true))
//                                .onAppear {
//                                    isTextVisible = false
//                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
            }

        }
    }
}

struct Train_Previews: PreviewProvider {
    
    static let departureSchedules: [TrainStation.DepartureSchedule] = [
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(70)),
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(2 * 60)),
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(3 * 60)),
            destinationStation: DestinationType.lebakBulus,
            isWeekend: false
        ),
        .init(
            timeDeparture: Date.now.addingTimeInterval(TimeInterval(4 * 60)),
            destinationStation: DestinationType.bundaranHI,
            isWeekend: false
        )
    ]
    
    static let trainStation: TrainStation = .init(
        stationId: 1,
        name: "Dukuh Atas",
        stationOrder: 11,
        departureSchedules: departureSchedules,
        estimateDestinations: []
    )
    static var previews: some View {
        TrainBanner(
            trainStation: trainStation,
            destinationStation: .bundaranHI
        )
        
    }
}
