//
//  SwiftDataManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI
import SwiftData
import WidgetKit

// MARK: - SwiftDataManagerProtocol
protocol SwiftDataManagerProtocol {
    func fetchData() -> [BabyActivity]
    func addActivity(_ activity: BabyActivity) throws
    func deleteActivity(activity: BabyActivity)
    func fetchFilteredActivities(with selectedActivityTypes: [ActivityCategory]) -> [BabyActivity]
    func fetchFiltered(with date: Date) -> [BabyActivity]
    func clearAllData()
}

// MARK: - SwiftDataManager
/// A class responsible for managing persistent data storage for baby activities.
///
/// Uses SwiftData to manage activities and ensures thread safety and proper error handling.
final class SwiftDataManager: SwiftDataManagerProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    // for widget
    private let sharedDefaults = UserDefaults(suiteName: "group.marmotmonitor")

    @MainActor
    static let shared = SwiftDataManager()

    /// Initializes the `SwiftDataManager` with an optional in-memory configuration for testing purposes.
    /// - Parameter isStoredInMemoryOnly: If `true`, data is stored in memory only (useful for tests).
    @MainActor
    init(isStoredInMemoryOnly: Bool = false) {
        do {
            self.modelContainer = try ModelContainer(
                for: BabyActivity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
            )
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    // MARK: - Data Management Methods

    /// Adds a new activity to the data store.
    /// - Parameter activity: The activity to add.
    /// - Throws: An error if the activity overlaps with an existing one.
    func addActivity(_ activity: BabyActivity) throws {
        if hasActivityOverlapping(activity) {
            throw ActivityError.overlappingActivity
        } else {
            modelContext.insert(activity)
            save()
        }
    }

    /// Deletes an existing activity from the data store.
    /// - Parameter activity: The activity to delete.
    func deleteActivity(activity: BabyActivity) {
        modelContext.delete(activity)
        save()
    }

    /// Clears all `BabyActivity` data from the store.
    func clearAllData() {
        try? modelContext.delete(model: BabyActivity.self)
        save()
    }

    /// Saves changes to the data store and notifies listeners.
    private func save() {
        print("save")
        try? modelContext.save()
        saveActivitiesForWidget()
        NotificationCenter.default.post(name: .dataUpdated, object: nil)
    }

    // MARK: - Fetch data
    /// Fetches all activities from the data store, sorted by date in ascending order.
    /// - Returns: An array of `BabyActivity`.
    func fetchData() -> [BabyActivity] {
        do {
            let descriptor = FetchDescriptor<BabyActivity>(sortBy: [SortDescriptor(\.date, order: .forward)])
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// Fetches activities filtered by specific activity categories.
    /// - Parameter selectedActivityTypes: The categories to filter by.
    /// - Returns: An array of filtered `BabyActivity`.
    func fetchFilteredActivities(with selectedActivityTypes: [ActivityCategory]) -> [BabyActivity] {
        let selectedActivityTypes = selectedActivityTypes.map { $0.rawValue }
        do {
            let predicate = #Predicate<BabyActivity> { activity in
                selectedActivityTypes.contains(activity.activityCategory)
            }

            let descriptor = FetchDescriptor<BabyActivity>(
                predicate: predicate,
                sortBy: [SortDescriptor(
                    \.date,
                     order: .reverse
                )]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// Fetches activities for a specific day.
    /// - Parameter date: The date to filter by.
    /// - Returns: An array of activities occurring on the given date.
    func fetchFiltered(with date: Date) -> [BabyActivity] {
        let startOfDay = Calendar.current.startOfDay(for: date)

        guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) else {
            fatalError("Unable to calculate end of day")
        }

        do {
            let predicate = #Predicate<BabyActivity> { activity in
                activity.date >= startOfDay && activity.date <= endOfDay
            }

            let descriptor = FetchDescriptor<BabyActivity>(
                predicate: predicate,
                sortBy: [SortDescriptor(
                    \.date,
                     order: .reverse
                )]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - Helper Methods

    /// Checks if a new activity overlaps with existing ones.
    /// - Parameter newActivity: The new activity to check.
    /// - Returns: `true` if an overlap exists, `false` otherwise.
    private func hasActivityOverlapping(_ newActivity: BabyActivity) -> Bool {

        let activities = fetchFilteredActivities(with: [newActivity.getCategory()])

        for activity in activities {
            switch (newActivity.activity, activity.activity) {
            case (.sleep(let newDuration), .sleep(let existingDuration)):
                let newStart = newActivity.date
                let newEnd = newActivity.date.addingTimeInterval(newDuration)
                let existingStart = activity.date
                let existingEnd = activity.date.addingTimeInterval(existingDuration)

                if newStart <= existingEnd && newEnd >= existingStart {
                    return true
                }

            case (.diaper, .diaper):
                if areDatesEqualIgnoringSeconds(newActivity.date, activity.date) {
                    return true
                }

            case (.bottle, .bottle):
                if areDatesEqualIgnoringSeconds(newActivity.date, activity.date) {
                    return true
                }

            case (.breast, .breast):
                if areDatesEqualIgnoringSeconds(newActivity.date, activity.date) {
                    return true
                }

            case (.growth, .growth):
                if areDatesEqualIgnoringTime(newActivity.date, activity.date) {
                    return true
                }

            default:
                continue
            }
        }

        return false
    }

    // MARK: - widget methods
    func saveActivitiesForWidget() {
        var lastData: [ActivityCategory: Date] = [:]
        lastData[.sleep] = fetchFilteredActivities(with: [.sleep]).first?.date
        lastData[.diaper] = fetchFilteredActivities(with: [.diaper]).first?.date
        lastData[.food] = fetchFilteredActivities(with: [.food]).first?.date

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(lastData) {
            sharedDefaults?.set(encoded, forKey: "widgetActivities")
            WidgetCenter.shared.reloadTimelines(ofKind: "MarmotMonitorWidget")
        }
    }
}

// MARK: - Date extension
extension SwiftDataManager {
    /// Compares two dates, ignoring seconds.
    func areDatesEqualIgnoringSeconds(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current

        let components1 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date2)

        return components1 == components2
    }

    /// Compares two dates, ignoring time.
    func areDatesEqualIgnoringTime(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current

        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

        return components1 == components2
    }
}
