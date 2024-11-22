//
//  RowManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI

final class RowManager {
    var activity: BabyActivity

    init(babyActivity: BabyActivity) {
        self.activity = babyActivity
    }

    var title: String {
        activity.activityTitre
    }

    var lastActivity: String {
        timeIntervalBetweenNowAnd(date: activity.date)
    }

    var information: String {
        getDescription()
    }

    var accessibilityDescription: String {
        let description = title + " " + lastActivity + " " + information
        return description.replacingOccurrences(of: "\n", with: " ")
    }

    var imageName: String {
        activity.activityImageName
    }

    var color: Color {
        Color(activity.activityColor)
    }

    // MARK: - Functions
    private func timeIntervalBetweenNowAnd(date: Date) -> String {
        let difference = Date().timeIntervalSince(date)
        let minutes = Int(difference / 60) % 60
        let hours = Int(difference / 3600)
        let days = Int(difference / 86400)

        if days > 0 {
            return "Il y a \(days) jour\(days > 1 ? "s" : "")"
        } else if hours > 0 {
            return "Il y a \(hours) h\(minutes > 0 ? " \(minutes) min" : "")"
        } else if minutes > 0 {
            return "Il y a \(minutes) minute\(minutes > 1 ? "s" : "")"
        } else {
            return "Maintenant"
        }
    }

    private func getDescription() -> String {
        switch activity.activity {
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
