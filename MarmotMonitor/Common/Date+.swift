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

    /// give time with hour and nimute in string
    /// - Parameter format: Le format par default "HH:mm" for 24 h.
    /// - Returns: String with hour and minute
    func detailedTimeBetweenDatesAndNow() -> String {
        let interval = Int(Date().timeIntervalSince(self))
        let days = interval / 86400
        let hours = (interval % 86400) / 3600
        let minutes = (interval % 3600) / 60

        var result = ""
        if days > 0 { result += "\(days) j " }
        if hours > 0 || days > 0 { result += "\(hours)h " }
        if minutes > 0 && hours > 0 { result += "\(minutes < 10 ? "0" : "")\(minutes)\(days > 0 ? "m" : "")"}
        if minutes > 0 && hours == 0 { result += "\(minutes < 10 ? "0" : "")\(minutes) m" }

        if result.isEmpty { return "\nMaintenant" }
        return "Il y a\n" + result.trimmingCharacters(in: .whitespaces)
    }
}
