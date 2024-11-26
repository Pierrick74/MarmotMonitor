//
//  TodayViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2024.
//

import SwiftUI

@MainActor
final class TodayViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var lastSleepActivity: BabyActivity?
    @Published var lastDiaperActivity: BabyActivity?
    @Published var lastFoodActivity: BabyActivity?
    @Published var lastGrowthActivity: BabyActivity?

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        refreshData()
    }

    // MARK: - Functions
    private func getLastActivity(of category: ActivityCategory) -> BabyActivity? {
        let activities = dataManager.fetchFilteredActivities(with: [category])
        if category == .sleep {
            print(activities.count)
            for activity in activities {
                print(activity.date)
            }
            print(activities.first?.date as Any)
    }
        return activities.first
    }

    func refreshData() {
        lastSleepActivity = getLastActivity(of: .sleep)
        lastDiaperActivity = getLastActivity(of: .diaper)
        lastFoodActivity = getLastActivity(of: .food)
        lastGrowthActivity = getLastActivity(of: .growth)
    }
}
