//
//  TodayViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2024.
//

import SwiftUI

@MainActor
final class TodayViewManager {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    // MARK: - Functions
    func getLastActivity(of category: ActivityCategory) -> BabyActivity? {
        let activities = dataManager.fetchFilteredActivities(with: [category])
        return activities.first
    }

    var lastSleepActivity: BabyActivity? {
        getLastActivity(of: .sleep)
    }

    var lastDiaperActivity: BabyActivity? {
        getLastActivity(of: .diaper)
    }

    var lastFoodActivity: BabyActivity? {
        getLastActivity(of: .food)
    }

    var lastGrowthActivity: BabyActivity? {
        getLastActivity(of: .growth)
    }
}
