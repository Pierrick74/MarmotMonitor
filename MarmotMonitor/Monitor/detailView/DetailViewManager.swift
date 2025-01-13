//
//  DetailViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//

import SwiftUI

/// A view model for managing and formatting activity data for a specific date.
@MainActor
final class DetailViewManager: ObservableObject {
    // MARK: - dependencies
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    // MARK: - Published Properties
    var date: Date

    @Published var formattedActivityData: [ActivityDetail] = []

    // MARK: - Initialization
    init(dataManager: SwiftDataManagerProtocol? = nil, date: Date) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        self.date = date
    }

    // MARK: - Functions
    func fetchActivityData() {
        let activities = dataManager.fetchFiltered(with: date)
        formattedActivityData = formatActivityData(activities)
    }

    func deleteActivity(_ activity: ActivityDetail) {
        let activities = dataManager.fetchFiltered(with: activity.date)
        for act in activities {
            if act.activityTitre == activity.type && act.date == activity.date {
                dataManager.deleteActivity(activity: act)
            }
        }
    }

    // MARK: - Private
    /// Formats raw activity data into a displayable format.
    /// - Parameter activities: The raw `BabyActivity` data to format.
    /// - Returns: An array of `ActivityDetail` excluding growth activities.
    private func formatActivityData(_ activities: [BabyActivity]) -> [ActivityDetail] {
        activities.compactMap { activity -> ActivityDetail? in
            guard activity.activityCategory != ActivityCategory.growth.rawValue else { return nil }
            return ActivityDetail(from: activity)
        }
    }
}
