//
//  ActivityDetail.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//
import SwiftUI
/// Represents the details of a specific activity, designed to be used in activity-related views.
/// - Parameters:
///  - icon: The name of the activity's icon.
///  - color: The color associated with the activity.
///  - type: The type of the activity.
///  - startHour: The time at which the activity started.
///  - value: The value associated with the activity.
///  - date: The date of the activity.
///  - id: The unique identifier of the activity detail.

struct ActivityDetail: Identifiable {
    let id = UUID()
    var icon: String
    let color: Color
    let type: String
    let startHour: String
    let value: String
    let date: Date

    init(from activity: BabyActivity) {
        self.icon = activity.activityImageName
        self.color = Color(activity.activityColor)
        self.type = activity.activityTitre
        self.startHour = activity.date.toHourMinuteString()
        self.value = ActivityDetail.formatValue(from: activity.activity)
        self.date = activity.date
    }

    /// Formats the value of an activity based on its type.
    ///
    /// - Parameter activity: The specific activity to extract the value from.
    /// - Returns: A string representation of the activity's value.
    private static func formatValue(from activity: ActivityType) -> String {
        switch activity {
        case .breast, .growth:
            return ""
        case .diaper(let type):
            return type.rawValue
        case .bottle(let volume, let measurementSystem):
            let unit = measurementSystem == .metric ? "ml" : "oz"
            return "\(volume) \(unit)"
        case .sleep(let duration):
            return Int(duration).toHourMinuteString()
        }
    }
}
