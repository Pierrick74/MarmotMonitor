//
//  Date+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    /// give time with hour and nimute in string
    /// - Parameter format: Le format par default "HH:mm" for 24 h.
    /// - Returns: String with hour and minute
    func toHourMinuteString(format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
