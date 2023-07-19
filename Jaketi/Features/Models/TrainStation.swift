//
//  TrainSchedule.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import Foundation

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

struct TrainStation: Hashable {
    var id: UUID = UUID()
    var name: String
    var departureSchedules: [DepartureSchedule]
    
    struct DepartureSchedule: Hashable {
        var id: UUID = UUID()
        var timeDeparture: Date
        var destinationStation: DestinationType
        var isWeekend: Bool = false
    }
}
