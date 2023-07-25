//
//  NearestTrain.swift
//  Jaketi
//
//  Created by Hilmy Noerfatih on 21/07/23.
//

import SwiftUI

struct TrainBanner: View {
    @State private var isTextVisible = false
        
    public var destinationStation: DestinationType
    public var departureSchedules: [TrainStation.DepartureSchedule]
    private var estimateTimeInMinute: Int = 0
    private let isAvailable: Bool
    private let isArrived: Bool
    
    init(destinationStation: DestinationType, departureSchedules: [TrainStation.DepartureSchedule]) {
        let viewModel = TrainStationViewModel()
        
        self.destinationStation = destinationStation
        self.departureSchedules = departureSchedules
        self.estimateTimeInMinute = viewModel.getFirstDepartureScheduleMinutes(departureSchedules)
        self.isAvailable = estimateTimeInMinute > -999
        self.isArrived = estimateTimeInMinute <= 0
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack{
                    Image("stripes")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                    Spacer()
                }
                .background(Theme.Colors.highlighted)
                .cornerRadius(10)
                HStack {
                    Spacer()
                    VStack{
                        HStack {
                            Spacer()
                            HStack {
                                Image(systemName:"train.side.front.car").foregroundColor(Theme.Colors.highlightedTag)
                                Text("Bound for \(destinationStation.getLabel())")
                                    .foregroundColor(Theme.Colors.highlightedTag)
                            }
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Theme.Colors.green)
                            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                        }
                        
                        
                        HStack {
                            Spacer()
                            if isAvailable{
                                Text(isArrived ? "Arrived at platform": "Arriving in \(estimateTimeInMinute) Minutes")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .opacity(isTextVisible ? 1.0 : 0.2)
                                    .foregroundColor(Theme.Colors.highlightedLabel)
                                    .animation(isTextVisible ? Animation.easeOut(duration: 0.7)
                                                    .repeatForever(autoreverses: true) : .default, value: isTextVisible)
                                    .onAppear {
                                        isTextVisible = true
                                    }
                                    .onDisappear{
                                        isTextVisible = false
                                    }
                            } else{
                                Text("Train Unavailable")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.red)
                                    .opacity(isTextVisible ? 1.0 : 0.2)
                                    .animation(isTextVisible ? Animation.easeOut(duration: 0.7)
                                                    .repeatForever(autoreverses: true) : .default, value: isTextVisible)
                                    .onAppear {
                                        isTextVisible = true
                                    }
                                    .onDisappear{
                                        isTextVisible = false
                                    }
                            }

                        }
                    }
                }    
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(getAccesibilityLabel())
            .padding(.horizontal, 16)

        }
    }
    
    func getAccesibilityLabel() -> String {
        if isAvailable {
            if isArrived {
                return "the nearest train to \(destinationStation.getLabel()) arrived at platform"
            } else {
                return "the nearest train to \(destinationStation.getLabel()) will arrive in \(estimateTimeInMinute) minutes"
            }
        } else {
            return "the train to \(destinationStation.getLabel()) is no longer available"
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
    static let emptyDepartureSchedules: [TrainStation.DepartureSchedule] = []
    
    static let trainStation: TrainStation = .init(
        stationId: 1,
        name: "Dukuh Atas",
        stationOrder: 11,
        departureSchedules: departureSchedules,
        estimateDestinations: []
    )
    static var previews: some View {
        VStack {
            TrainBanner(
                destinationStation: .bundaranHI, departureSchedules: departureSchedules
            )
        }

    }
}
