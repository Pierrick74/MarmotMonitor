//
//  RowManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI
/// Manages the data and logic for displaying a row in a baby activity list.
final class RowManager {
    private var activity: BabyActivity?
    private var category: ActivityCategory

    /// Initializes the manager with an activity and a category.
    /// - Parameters:
    ///   - babyActivity: The associated baby activity, if any.
    ///   - category: The category of the activity.
    init(babyActivity: BabyActivity?, category: ActivityCategory) {
        self.activity = babyActivity
        self.category = category
    }

    // MARK: - Computed Properties
    var title: String {
        activity?.activityTitre ?? category.rawValue
    }

    var lastActivity: String {
        if let date =  getLastDateActivity(of: activity) {
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
    /// Returns a string representing the time interval between now and a given date.
    /// - Parameter date: The date to compare with the current date.
    /// - Returns: A formatted string representing the time interval.
    private func timeIntervalBetweenNowAnd(date: Date) -> String {
        let difference = Date().timeIntervalSince(date)
        let minutes = Int(difference / 60) % 60
        let hours = Int(difference / 3600)
        let days = Int(difference / 86400)

        switch true {
        case days > 0:
            return "Il y a \(days) jour\(days > 1 ? "s" : "")"
        case hours > 0:
            return "Il y a \(hours) h\(minutes > 0 ? " \(minutes) min" : "")"
        case minutes > 0:
            return "Il y a \(minutes) minute\(minutes > 1 ? "s" : "")"
        default:
            return "Maintenant"
        }
    }

    /// Returns a string description of a given activity type.
    /// - Parameter activity: The activity type to describe.
    /// - Returns: A string description of the activity.
    private func getDescription(of activity: ActivityType) -> String {
        switch activity {
        case .bottle(let volume, let unit ):
            return "\(Int(volume))\n\(unit == .metric ? "ml" : "oz")"
        case .sleep(let duration):
            let hours = Int(duration) / 3600
            let minutes = (Int(duration) % 3600) / 60

            return hours > 0
                    ? "\(hours) h\(minutes > 0 ? " \(minutes) min" : "")"
                    : "\(minutes)\nmin"

        case .diaper(let state):
            return state.rawValue
        case .growth(let data):
            let weight = data.weight.map { "\(Int($0)) \(data.measurementSystem == .metric ? "kg" : "lbs")" } ?? ""
            let height = data.height.map { "\(Int($0)) \(data.measurementSystem == .metric ? "cm" : "in")" } ?? ""
            return [weight, height].filter { !$0.isEmpty }.joined(separator: "\n")
        default: return ""
        }
    }

    /// Returns the last activity date for a given baby activity.
    /// - Parameter babyActivity: The baby activity to analyze.
    /// - Returns: The last activity date, if applicable.
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
