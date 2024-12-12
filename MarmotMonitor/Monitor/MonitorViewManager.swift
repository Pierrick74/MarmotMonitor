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

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        createActivityDataInRange()
    }

    @Published var formattedActivityData: [Date: [ActivityRange]] = [:]
    @Published private var filter: [ActivityCategory] = [.diaper, .food, .sleep]

    var isSleepSelected: Bool { filter.contains(.sleep) }
    var isDiaperSelected: Bool {filter.contains(.diaper) }
    var isFoodSelected: Bool { filter.contains(.food) }

    // MARK: - Functions
    func createActivityDataInRange() {
        formattedActivityData = [:]
        let babyActivities = dataManager.fetchFilteredActivities(with: filter)

        for data in babyActivities {
            var range: ActivityRange?
            var rangeDayPlusOne: ActivityRange?

            switch data.activity {
            case .sleep(let duration):
                if checkIfDayNotChanged(with: data.date, duration: duration) {
                    // Le sommeil ne dépasse pas minuit
                    let startHour = transformInRange(data.date)
                    let endDate = data.date.addingTimeInterval(TimeInterval(duration))
                    let endHour = transformInRange(endDate)
                    let durationInMinutes = formatDuration(duration)

                    range = ActivityRange(
                        startHour: startHour,
                        endHour: endHour,
                        type: .sleep,
                        value: durationInMinutes,
                        unit: nil
                    )
                } else {
                    // Le sommeil dépasse minuit
                    let calendar = Calendar.current
                    let midnight = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: data.date)!)

                    // Première portion jusqu'à minuit
                    let firstDuration = midnight.timeIntervalSince(data.date)
                    let startHour = transformInRange(data.date)
                    let endHour = 48
                    let durationInMinutes = formatDuration(firstDuration)

                    range = ActivityRange(
                        startHour: startHour,
                        endHour: endHour,
                        type: .sleep,
                        value: durationInMinutes,
                        unit: nil
                    )

                    // Deuxième portion à partir de minuit
                    let secondDuration = duration - firstDuration
                    let startHourDayPlusOne = 0
                    let endHourDayPlusOne = transformInRange(midnight.addingTimeInterval(secondDuration))
                    let durationInMinutesDayPlusOne = formatDuration(secondDuration)

                    rangeDayPlusOne = ActivityRange(
                        startHour: startHourDayPlusOne,
                        endHour: endHourDayPlusOne,
                        type: .sleep,
                        value: durationInMinutesDayPlusOne,
                        unit: nil
                    )
                }

            case .diaper:
                let startHour = transformInRange(data.date)
                let endHour = startHour + 1
                range = ActivityRange(
                    startHour: startHour,
                    endHour: endHour,
                    type: .diaper,
                    value: nil,
                    unit: nil)

            case .bottle(volume: let volume, measurementSystem: let measurementSystem):
                let startHour = transformInRange(data.date)
                let endHour = startHour + 1
                range = ActivityRange(
                    startHour: startHour,
                    endHour: endHour,
                    type: .food,
                    value: Double(Int(volume)),
                    unit: measurementSystem)

            case .breast(duration: let duration, lastBreast: _):
                let startHour = transformInRange(data.date)
                let interval = duration.leftDuration + duration.rightDuration

                let endDate = data.date.addingTimeInterval(TimeInterval(interval))
                let endHour = transformInRange(endDate)

                range = ActivityRange(
                    startHour: startHour,
                    endHour: endHour,
                    type: .food,
                    value: nil,
                    unit: nil)

            case .growth:
                range = nil
            }

            let savedData = Calendar.current.startOfDay(for: data.date)
            if let unwrappRange = range {
                if formattedActivityData[savedData] != nil {
                    formattedActivityData[savedData]?.append(unwrappRange)
                } else {
                    formattedActivityData[savedData] = [unwrappRange]
                }
            }

            if let unwrappedRangeDayPlusOne = rangeDayPlusOne {
                let savedDataPlusOne = Calendar.current.startOfDay(for: data.date.addingTimeInterval(86400))
                if formattedActivityData[savedDataPlusOne] != nil {
                    formattedActivityData[savedDataPlusOne]?.append(unwrappedRangeDayPlusOne)
                } else {
                    formattedActivityData[savedDataPlusOne] = [unwrappedRangeDayPlusOne]
                }
            }
        }
    }

    private func transformInRange(_ date: Date) -> Int {
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

    func toggleFilter(_ category: ActivityCategory) {
        if filter.contains(category) {
            filter.removeAll { $0 == category }
        } else {
            filter.append(category)
        }
        createActivityDataInRange()
    }
}
