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

    func createActivityDataInRange() {
        formattedActivityData = [:]
        let babyActivities = dataManager.fetchData()

        for data in babyActivities {
            var range: ActivityRange?
            switch data.activity {
            case .sleep(let duration):
                let startHour = transformInRange(data.date)
                let endDate = data.date.addingTimeInterval(TimeInterval(duration))
                let endHour = transformInRange(endDate)
                let durationInMinutes = formatDuration(duration)

                range = ActivityRange(startHour: startHour, endHour: endHour, type: .sleep, value: durationInMinutes, unit: nil)

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
                print("je suis passé ici")
                if formattedActivityData[savedData] != nil {
                    print("diff de nil")
                    formattedActivityData[savedData]?.append(unwrappRange)
                } else {
                    print("nil")
                    formattedActivityData[savedData] = [unwrappRange]
                }
            }
        }
        print("formattedActivityData: \(formattedActivityData)")
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
}
