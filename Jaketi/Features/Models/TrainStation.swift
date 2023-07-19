//
//  TrainSchedule.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import Foundation

struct TrainStation: Hashable {
    var id: UUID = UUID()
    var name: String
    var schedules: [Schedule]
    
    struct Schedule: Hashable {
        var id: UUID = UUID()
        var time: String
    }
}
