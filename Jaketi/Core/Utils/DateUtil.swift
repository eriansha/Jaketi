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
    dateFormatter.dateFormat = format // Set the date format

    return dateFormatter.date(from: dateString)
}
