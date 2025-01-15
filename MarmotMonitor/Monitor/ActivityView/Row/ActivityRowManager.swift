//
//  ActivityRowManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2024.
//

import SwiftUI

/// A manager for handling activity data and providing utilities for color coding and legend generation.
/// - Parameters:
///  - data: an array of ActivityRange

struct ActivityRowManager {
    private let data: [ActivityRange]

    init(data: [ActivityRange]) {
        self.data = data
    }

    var accessibilitéInformation: String = ""
    // MARK: - Public Methods
    /// Returns the color associated with a specific hour based on the activity data.
    ///
    /// - Parameter hour: The hour to retrieve the color for, in 24-hour format.
    /// - Returns: A `Color` representing the activity at the given hour, or `.clear` if no activity is found.
    func color(for hour: Int) -> Color {
        let sortedData = data.sorted { lhs, rhs in
            priority(for: lhs.type) > priority(for: rhs.type)
        }

        for range in sortedData {
            if hour >= range.startHour && hour < range.endHour {
                return range.type.colorBarre
            }
        }

        return .clear
    }

    /// Generates a legend based on the activity data.
    ///
    /// - Returns: An array of `ActivityLegendData` containing aggregated information for each activity type.
    func generateLegend() -> [ActivityLegendData] {
        var legendData: [ActivityCategory: (recurency: Int, total: Double?, unit: MeasurementSystem?)] = [:]

        for range in data {
            let current = legendData[range.type] ?? (recurency: 0, total: nil, unit: nil)

            switch range.type {
            case .sleep:
                let duration = range.value ?? 0
                legendData[.sleep] = (
                    recurency: current.recurency + 1,
                    total: (current.total ?? 0) + duration,
                    unit: range.unit
                )

            case .food:
                let volume = range.value ?? 0
                legendData[.food] = (
                    recurency: current.recurency + 1,
                    total: (current.total ?? 0) + volume,
                    unit: range.unit
                )

            case .diaper:
                legendData[.diaper] = (
                    recurency: current.recurency + 1,
                    total: nil,
                    unit: nil
                )

            case .growth:
                continue
            }
        }

        return legendData.map { (type, data) in
            ActivityLegendData(
                type: type,
                recurency: data.recurency,
                total: data.total,
                unit: data.unit
            )
        }.sorted { priority(for: $0.type) < priority(for: $1.type)}
    }

    // MARK: - Private Methods
    /// Returns the priority level of a specific activity type.
    ///
    /// - Parameter type: An `ActivityCategory` to evaluate.
    /// - Returns: An integer priority value, higher numbers indicate higher priority.
    private func priority(for type: ActivityCategory) -> Int {
        switch type {
        case .food: return 3
        case .diaper: return 2
        case .sleep: return 1
        case .growth: return 0
        }
    }
}

/// Represents an activity interval with start and end times, type, and optional value.
struct ActivityRange {
    let startHour: Int
    let endHour: Int
    let type: ActivityCategory
    let value: Double?
    let unit: MeasurementSystem?
}
