//
//  DateUtil.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import Foundation

func convertDateToString(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    
    return dateFormatter.string(from: date)
}

func convertStringToDate(dateString: String, format: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format

    return dateFormatter.date(from: dateString)
}

func isWeekend() -> Bool {
    let calendar = Calendar.current
    let today = Date()
    
    // Get the day of the week for the current date (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    let dayOfWeek = calendar.component(.weekday, from: today)
    
    // Check if the day of the week is Saturday (6) or Sunday (1)
    return dayOfWeek == 1 || dayOfWeek == 7
}
