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

struct TrainStation: Hashable, Decodable {
    var id: UUID = UUID()
    var stationId: Int
    var name: String
    var departureSchedules: [DepartureSchedule]
    
    enum CodingKeys: String, CodingKey {
        case stationId = "nid"
        case title = "title"
        case scheduleLBWeekday = "jadwal_lb_biasa"
        case scheduleLBWeekend = "jadwal_lb_libur"
        case scheduleHIWeekday = "jadwal_hi_biasa"
        case scheduleHIWeekend = "jadwal_hi_libur"
    }
    
    struct DepartureSchedule: Hashable {
        var id: UUID = UUID()
        var timeDeparture: Date
        var destinationStation: DestinationType
        var isWeekend: Bool = false
        
        init(timeDeparture: Date, destinationStation: DestinationType, isWeekend: Bool) {
            self.id = UUID()
            self.timeDeparture = timeDeparture
            self.destinationStation = destinationStation
            self.isWeekend = isWeekend
        }
    }
    
    init(stationId: Int, name: String, departureSchedules: [DepartureSchedule]) {
        self.id = UUID()
        self.name = name
        self.stationId = stationId
        self.departureSchedules = departureSchedules
    }

    init(from decoder: Decoder) throws {
        // Decode value from JSON
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stationName = try container.decode(String.self, forKey: .title)
        let stationId = try container.decode(String.self, forKey: .stationId)
        let scheduleLebakBulusWeekday = try container.decode(
            String?.self,
            forKey: .scheduleLBWeekday
        )
        let scheduleLebakBulusWeekend = try container.decode(
            String?.self,
            forKey: .scheduleLBWeekend
        )
        let scheduleHIWeekday = try container.decode(String?.self, forKey: .scheduleHIWeekday)
        let scheduleHIWeekend = try container.decode(String?.self, forKey: .scheduleHIWeekend)
        
        let viewModel = TrainStationViewModel()
        
        // Assign and transform each value into Train station properties
        self.id = UUID()
        self.name = stationName
        self.stationId = Int(stationId)!
        self.departureSchedules = viewModel.mergeDepartureSchedule(
            scheduleLBWeekday: scheduleLebakBulusWeekday,
            scheduleLBWeekend: scheduleLebakBulusWeekend,
            scheduleHIWeekday: scheduleHIWeekday,
            scheduleHIWeekend: scheduleHIWeekend
        )
    }
}
