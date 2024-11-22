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
    func addActivity(activity: BabyActivity)
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

    func addActivity(activity: BabyActivity) {
        modelContext.insert(activity)
        save()
    }

    func deleteActivity(activity: BabyActivity) {
        modelContext.delete(activity)
        save()
    }

    func save() {
        try? modelContext.save()
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

            let descriptor = FetchDescriptor<BabyActivity>(predicate: predicate, sortBy: [SortDescriptor(\.date, order: .forward)])
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
