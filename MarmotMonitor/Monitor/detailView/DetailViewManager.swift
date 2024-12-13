//
//  DetailViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//

import SwiftUI

@MainActor
class DetailViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    init(dataManager: SwiftDataManagerProtocol? = nil, date: Date) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        self.date = date
    }

    @Published var formattedActivityData: [ActivityDetail] = []
    var date: Date

    func fetchActivityData() {
        let activities = dataManager.fetchFiltered(with: date)
        formattedActivityData = formatActivityData(activities)
    }

    private func formatActivityData(_ activities: [BabyActivity]) -> [ActivityDetail] {
        activities.compactMap { activity -> ActivityDetail? in
            guard activity.activityCategory != ActivityCategory.growth.rawValue else { return nil }

            let icon = activity.activityImageName
            let color = Color(activity.activityColor)
            let type = activity.activityTitre
            let startHour = activity.date.toHourMinuteString()
            let value = getValue(for: activity)
            let date = activity.date

            return ActivityDetail(icon: icon, color: color, type: type, startHour: startHour, value: value, date: date)
        }.compactMap { $0 }
    }

    private func getValue(for activity: BabyActivity) -> String {
        switch activity.activity {
        case .breast, .growth:
            return ""
        case .diaper(let type):
            return type.rawValue
        case .bottle(let volume, let measurementSystem):
            let unit = measurementSystem == .metric ? "ml" : "oz"
            return "\(volume) \(unit)"
        case .sleep(let duration):
            return Int(duration).toHourMinuteString() + " h"
        }
    }

    // MARK: - Delete Action
    func deleteActivity(_ activity: ActivityDetail) {
        let activities = dataManager.fetchFiltered(with: activity.date)
        for act in activities {
            if act.activityTitre == activity.type && act.date == activity.date {
                dataManager.deleteActivity(activity: act)
            }
        }
    }
}

struct ActivityDetail: Identifiable {
    let id = UUID()
    var icon: String
    let color: Color
    let type: String
    let startHour: String
    let value: String
    let date: Date
}
