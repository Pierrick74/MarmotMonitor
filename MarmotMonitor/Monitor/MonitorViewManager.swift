//
//  MonitorViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/12/2024.
//

import SwiftUI
/// Manager for the MonitorView
@MainActor
class MonitorViewManager: ObservableObject {
    // MARK: - Dependencies
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    // MARK: - Published Properties
    @Published var formattedActivityData: [Date: [ActivityRange]] = [:]
    @Published private var filter: [ActivityCategory] = [.diaper, .food, .sleep]

    // MARK: - Computed Properties
    var isSleepSelected: Bool { filter.contains(.sleep) }
    var isDiaperSelected: Bool {filter.contains(.diaper) }
    var isFoodSelected: Bool { filter.contains(.food) }

    // MARK: - Init
    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        loadActivitiesInDateRange()
    }

    // MARK: - Functions
    /// Loads the activities in the date range and formats them for display.
    /// - Note: This function is called when the view is initialized.
    /// - Note: This function is called when the filter is toggled.
    func loadActivitiesInDateRange() {
        formattedActivityData = [:]
        let babyActivities = dataManager.fetchFilteredActivities(with: filter)

        for data in babyActivities {
            let ranges = createActivityRange(for: data)
            let savedData = Calendar.current.startOfDay(for: data.date)

            if let mainRange = ranges.main {
                addToFormattedActivityData(mainRange, for: savedData)
            }

            if let nextDayRange = ranges.nextDay {
                let savedDataPlusOne = Calendar.current.startOfDay(for: data.date.addingTimeInterval(86400))
                addToFormattedActivityData(nextDayRange, for: savedDataPlusOne)
            }
        }
    }

    /// Toggles the filter for the given category.
    /// - Parameter category: The category to toggle the filter for.
    func toggleFilter(_ category: ActivityCategory) {
        if filter.contains(category) {
            filter.removeAll { $0 == category }
        } else {
            filter.append(category)
        }
        loadActivitiesInDateRange()
    }

    // MARK: - Private functions
    private func createActivityRange(for activity: BabyActivity) -> (main: ActivityRange?, nextDay: ActivityRange?) {
        switch activity.activity {
        case .sleep(let duration):
            if checkIfDayNotChanged(with: activity.date, duration: duration) {
                let range = ActivityRange(
                    startHour: transformInRangeIndex(activity.date),
                    endHour: transformInRangeIndex(activity.date.addingTimeInterval(TimeInterval(duration))),
                    type: .sleep,
                    value: formatDuration(duration),
                    unit: nil
                )
                return (main: range, nextDay: nil)

            } else {
                let calendar = Calendar.current
                let midnight = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: activity.date)!)

                // before midnight
                let firstDuration = midnight.timeIntervalSince(activity.date)

                let range = ActivityRange(
                    startHour: transformInRangeIndex(activity.date),
                    endHour: 48,
                    type: .sleep,
                    value: formatDuration(firstDuration),
                    unit: nil
                )

                // after midnight
                let secondDuration = duration - firstDuration
                let rangeNextDay = ActivityRange(
                    startHour: 0,
                    endHour: transformInRangeIndex(midnight.addingTimeInterval(secondDuration)),
                    type: .sleep,
                    value: formatDuration(secondDuration),
                    unit: nil
                )
                return (main: range, nextDay: rangeNextDay)
            }

        case .diaper:
            return createDiaperRange(for: activity)

        case .bottle(volume: let volume, measurementSystem: let measurementSystem):
            return createBottleRange(at: activity.date, volume: volume, measurementSystem: measurementSystem)

        case .breast(duration: let duration, lastBreast: _):

            let interval = duration.leftDuration + duration.rightDuration
            let endDate = activity.date.addingTimeInterval(TimeInterval(interval))
            let endHour = transformInRangeIndex(endDate)

            let range = ActivityRange(
                startHour: transformInRangeIndex(activity.date),
                endHour: endHour,
                type: .food,
                value: nil,
                unit: nil)
            return (main: range, nextDay: nil)

        case .growth:
            return (main: nil, nextDay: nil)
        }
    }

    /// Creates a bottle range for the activity
    private func createBottleRange(at date: Date, volume: Double, measurementSystem: MeasurementSystem) -> (main: ActivityRange?, nextDay: ActivityRange?) {
        let range = ActivityRange(
            startHour: transformInRangeIndex(date),
            endHour: transformInRangeIndex(date) + 1,
            type: .food,
            value: Double(Int(volume)),
            unit: measurementSystem
        )
        return (main: range, nextDay: nil)
    }

    /// Creates a diaper range for the activity
    private func createDiaperRange(for activity: BabyActivity) -> (main: ActivityRange?, nextDay: ActivityRange?) {
        let range = ActivityRange(
            startHour: transformInRangeIndex(activity.date),
            endHour: transformInRangeIndex(activity.date) + 1,
            type: .diaper,
            value: nil,
            unit: nil)
        return (main: range, nextDay: nil)
    }

    /// Adds the range to the formatted activity data.
    private func addToFormattedActivityData(_ range: ActivityRange, for date: Date) {
        formattedActivityData[date, default: []].append(range)
    }

    /// Transforms a date into an index in the range [0, 47] for display purposes.
    private func transformInRangeIndex(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let totalMinutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
        return totalMinutes / 30
    }

    /// Formats the duration of the activity.
    /// - Parameter seconds: The duration of the activity in seconds.
    /// - Returns: The formatted duration in Double
    private func formatDuration(_ seconds: TimeInterval) -> Double {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) % 3600 / 60

        switch minutes {
        case 0..<30:
            return Double(hours) + 0.5
        default:
            return Double(hours) + 0.5
        }
    }

    /// Checks if the day has changed during the activity.
    private func checkIfDayNotChanged(with date: Date, duration: TimeInterval) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.startOfDay(for: date.addingTimeInterval(duration))
        return startOfDay == endOfDay
    }
}
