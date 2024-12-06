//
//  SwiftDataManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI
import SwiftData

// MARK: - SwiftDataManagerProtocol
protocol SwiftDataManagerProtocol {
    func fetchData() -> [BabyActivity]
    func addActivity(_ activity: BabyActivity) throws
    func deleteActivity(activity: BabyActivity)
    func fetchFilteredActivities(with selectedActivityTypes: [ActivityCategory]) -> [BabyActivity]
    func clearAllData()
}

// MARK: - SwiftDataManager
final class SwiftDataManager: SwiftDataManagerProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = SwiftDataManager()

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

    func addActivity(_ activity: BabyActivity) throws {
        if hasActivityOverlapping(activity) {
            throw ActivityError.overlappingActivity
        } else {
            modelContext.insert(activity)
            save()
        }
    }

    func deleteActivity(activity: BabyActivity) {
        modelContext.delete(activity)
        save()
    }

    func save() {
        try? modelContext.save()
        NotificationCenter.default.post(name: .dataUpdated, object: nil)
    }

    func clearAllData() {
        try? modelContext.delete(model: BabyActivity.self)
        save()
    }

    // MARK: - Fetch data

    func fetchData() -> [BabyActivity] {
        do {
            let descriptor = FetchDescriptor<BabyActivity>(sortBy: [SortDescriptor(\.date, order: .forward)])
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchFilteredActivities(with selectedActivityTypes: [ActivityCategory]) -> [BabyActivity] {
        let selectedActivityTypes = selectedActivityTypes.map { $0.rawValue }
        do {
            let predicate = #Predicate<BabyActivity> { activity in
                selectedActivityTypes.contains(activity.activityCategory)
            }

            let descriptor = FetchDescriptor<BabyActivity>(predicate: predicate, sortBy: [SortDescriptor(\.date, order: .reverse)])
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

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
}

// MARK: - Date extension
extension SwiftDataManager {
    func areDatesEqualIgnoringSeconds(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current

        let components1 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date2)

        return components1 == components2
    }

    func areDatesEqualIgnoringTime(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current

        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

        return components1 == components2
    }
}
