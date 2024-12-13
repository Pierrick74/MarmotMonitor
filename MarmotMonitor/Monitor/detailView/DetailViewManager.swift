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
    var date: Date

    @Published var formattedActivityData: [ActivityDetail] = []

    init(dataManager: SwiftDataManagerProtocol? = nil, date: Date) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        self.date = date
    }

    func fetchActivityData() {
        let activities = dataManager.fetchFiltered(with: date)
        formattedActivityData = formatActivityData(activities)
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

    // MARK: - Private
    private func formatActivityData(_ activities: [BabyActivity]) -> [ActivityDetail] {
        activities.compactMap { activity -> ActivityDetail? in
            guard activity.activityCategory != ActivityCategory.growth.rawValue else { return nil }
            return ActivityDetail(from: activity)
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
}
