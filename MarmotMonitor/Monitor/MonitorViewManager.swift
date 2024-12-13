//
//  MonitorViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/12/2024.
//

import SwiftUI

@MainActor
class MonitorViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var formattedActivityData: [Date: [ActivityRange]] = [:]
    @Published private var filter: [ActivityCategory] = [.diaper, .food, .sleep]

    var isSleepSelected: Bool { filter.contains(.sleep) }
    var isDiaperSelected: Bool {filter.contains(.diaper) }
    var isFoodSelected: Bool { filter.contains(.food) }

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        loadActivitiesInDateRange()
    }

    // MARK: - Functions
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
            let range = ActivityRange(
                startHour: transformInRangeIndex(activity.date),
                endHour: transformInRangeIndex(activity.date) + 1,
                type: .diaper,
                value: nil,
                unit: nil)
            return (main: range, nextDay: nil)

        case .bottle(volume: let volume, measurementSystem: let measurementSystem):
            let range = ActivityRange(
                startHour: transformInRangeIndex(activity.date),
                endHour: transformInRangeIndex(activity.date) + 1,
                type: .food,
                value: Double(Int(volume)),
                unit: measurementSystem)
            return (main: range, nextDay: nil)

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

    private func addToFormattedActivityData(_ range: ActivityRange, for date: Date) {
        if formattedActivityData[date] != nil {
            formattedActivityData[date]?.append(range)
        } else {
            formattedActivityData[date] = [range]
        }
    }

    private func transformInRangeIndex(_ date: Date) -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        let totalMinutes = (hour * 60) + minute
        return totalMinutes / 30
    }

    private func formatDuration(_ seconds: TimeInterval) -> Double {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) % 3600 / 60

        if minutes == 0 {
            return Double(hours)
        } else if minutes < 30 {
            return Double(hours) + 0.5
        } else {
            return Double(hours + 1)
        }
    }

    private func checkIfDayNotChanged(with date: Date, duration: TimeInterval) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.startOfDay(for: date.addingTimeInterval(duration))
        return startOfDay == endOfDay
    }
}
