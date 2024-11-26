//
//  RowManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI

final class RowManager {
    private var activity: BabyActivity?
    private var category: ActivityCategory

    init(babyActivity: BabyActivity?, category: ActivityCategory) {
        self.activity = babyActivity
        self.category = category
    }

    var title: String {
        activity?.activityTitre ?? category.rawValue
    }

    var lastActivity: String {
        if let date =  getLastDateActivity(of : activity) {
            return timeIntervalBetweenNowAnd(date: date)
        } else {
            return "Aucune activité renseignée"
        }
    }

    var information: String {
        if  let activity = activity {
            return getDescription(of: activity.activity)
        } else {
            return ""
        }
    }

    var accessibilityDescription: String {
        let description = title + " " + lastActivity + " " + information
        return description.replacingOccurrences(of: "\n", with: " ")
    }

    var imageName: String {
        category.rawValue
    }

    var color: Color {
        Color(category.rawValue)
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

    private func getDescription(of activity: ActivityType) -> String {
        switch activity {
        case .bottle(let volume, let unit ):
            return "\(Int(volume))\n\(unit == .metric ? "ml" : "oz")"
        case .sleep(let duration):
            let hours = Int(duration) / 3600
            let minutes = (Int(duration) % 3600) / 60

            if hours > 0 {
                return "\(hours) h\(minutes > 0 ? " \(minutes) min" : "")"
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

    private func getLastDateActivity(of babyActivity: BabyActivity?) -> Date? {
        guard let babyActivity = babyActivity else { return nil }

        switch babyActivity.activity {
        case .sleep(let duration):
            return babyActivity.date.addingTimeInterval(duration)
        default:
            return babyActivity.date
        }
    }
}
