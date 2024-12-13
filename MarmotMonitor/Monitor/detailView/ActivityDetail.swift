//
//  ActivityDetail.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//
import SwiftUI

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
        self.value = {
            switch activity.activity {
            case .diaper, .breast, .growth:
                return ""
            case .bottle(let volume, let measurementSystem):
                let unit = measurementSystem == .metric ? "ml" : "oz"
                return "\(volume) \(unit)"
            case .sleep(let duration):
                return Int(duration).toHourMinuteString()
            }
        }()
        self.date = activity.date
    }
}
