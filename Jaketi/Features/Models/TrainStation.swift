//
//  TrainSchedule.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import Foundation

enum DestinationType: CaseIterable {
    case bundaranHI
    case lebakBulus
    
    func getLabel() -> String {
        switch(self) {
        case .bundaranHI: return "Bundaran HI"
        case .lebakBulus: return "Lebak Bulus Grab"
        }
    }
}

struct TrainStation: Hashable, Decodable, Identifiable {
    var id: UUID = UUID()
    var stationId: Int
    var name: String
    var stationOrder: Int
    var departureSchedules: [DepartureSchedule]
    var estimateDestinations: [EstimateDestinations]
    
    enum CodingKeys: String, CodingKey {
        case stationId = "nid"
        case title = "title"
        case stationOrder = "urutan"
        case scheduleLBWeekday = "jadwal_lb_biasa"
        case scheduleLBWeekend = "jadwal_lb_libur"
        case scheduleHIWeekday = "jadwal_hi_biasa"
        case scheduleHIWeekend = "jadwal_hi_libur"
        case estimateDestinations = "estimasi"
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
    
    struct EstimateDestinations: Hashable, Codable {
        var id: UUID = UUID()
        var stationId : Int
        var stationName = ""
        var stationOrder = -1
        var price: Int
        var travelTime: Int
        
        enum CodingKeys: String, CodingKey {
            case stationId = "stasiun_nid"
            case price = "tarif"
            case travelTime = "waktu"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            stationId = Int(try container.decode(String.self, forKey: .stationId)) ?? 0
            price = Int(try container.decode(String.self, forKey: .price)) ?? 0
            travelTime = Int(try container.decode(String.self, forKey: .travelTime)) ?? 0
        }
        
        init(stationId: Int, price: Int, travelTime: Int) {
            self.stationId = stationId
            self.price = price
            self.travelTime = travelTime
        }
    }
    
    init(stationId: Int, name: String, stationOrder: Int , departureSchedules: [DepartureSchedule], estimateDestinations: [EstimateDestinations]) {
        self.id = UUID()
        self.name = name
        self.stationId = stationId
        self.stationOrder = stationOrder
        self.departureSchedules = departureSchedules
        self.estimateDestinations = estimateDestinations
    }

    init(from decoder: Decoder) throws {
        // Decode value from JSON
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stationName = try container.decode(String.self, forKey: .title)
        let stationId = try container.decode(String.self, forKey: .stationId)
        let stationOrder = try container.decode(String.self, forKey: .stationOrder)
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
        let estimateDestinations = try container.decode([EstimateDestinations].self, forKey: .estimateDestinations)
        
        let viewModel = TrainStationViewModel()
        
        // Assign and transform each value into Train station properties
        self.id = UUID()
        self.name = stationName
        self.stationId = Int(stationId)!
        self.stationOrder = Int(stationOrder)!
        self.departureSchedules = viewModel.mergeDepartureSchedule(
            scheduleLBWeekday: scheduleLebakBulusWeekday,
            scheduleLBWeekend: scheduleLebakBulusWeekend,
            scheduleHIWeekday: scheduleHIWeekday,
            scheduleHIWeekend: scheduleHIWeekend
        )
        self.estimateDestinations = estimateDestinations
    }
}
