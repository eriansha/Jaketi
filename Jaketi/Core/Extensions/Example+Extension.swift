//
//  Example+Extension.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import Foundation

// TODO: remove this file once you create new file inside this directory

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? Date()
    }
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
}
