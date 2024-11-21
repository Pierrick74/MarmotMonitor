//
//  RowManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI

final class RowManager {
    var activity: Activity
    var date: Date

    init(babyActivity: BabyActivity) {
        self.activity = babyActivity.activity
        self.date = babyActivity.date
    }

    var title: String {
        return activity.title
    }

    var lastActivity: String {
        return timeIntervalBetweenNowAnd(date: date)
    }

    var information: String {
        return getDescription()
    }

    var accessibilityDescription: String {
        let description = title + " " + lastActivity + " " + information
        return description.replacingOccurrences(of: "\n", with: " ")
    }

    var imageName: String {
        return activity.imageName
    }

    var color: Color {
        return activity.color
    }

    // MARK: - Functions
    private func timeIntervalBetweenNowAnd(date: Date) -> String {
        let difference = Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: .now)

        if let days = difference.day, days > 0 {
            return "Il y a \(days) jour\(days > 1 ? "s" : "")"
        } else if let hours = difference.hour, hours > 0 {
            let minutes = difference.minute ?? 0
            return "Il y a \(hours) h \(minutes > 1 ? "et \(minutes) m" : "")"
        } else if let minutes = difference.minute, minutes > 0 {
            return "Il y a \(minutes) minute\(minutes > 1 ? "s" : "")"
        } else {
            return "Maintenant"
        }
    }

    private func getDescription() -> String {
        switch activity.type {
        case .bottle(let volume, let unit ):
            return "\(Int(volume))\n\(unit == .metric ? "ml" : "oz")"
        case .sleep(let duration):
            let hours = Int(duration) / 3600
            let minutes = (Int(duration) % 3600) / 60

            if hours > 0 {
                return "\(hours) h\n\(minutes) min"
            } else {
                return "\(minutes)\nmin"
            }
        case .diaper(let state):
            return state.rawValue
        case .growth(let data):
            var weight = ""
            var height = ""

            if let weightValue = data.weight {
                weight = "\(Int(weightValue)) \(data.measurementSystem == .metric ? "kg" : "lbs")"
            }
            if let heightValue = data.height {
                height = "\(Int(heightValue)) \(data.measurementSystem == .metric ? "cm" : "in")"
            }
            return  weight + "\n" + height
        default: return ""
        }
    }
}
