//
//  ActivityRowManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2024.
//

import SwiftUI

/// Manager to handle the activity view
/// - Parameters:
///  - data: an array of ActivityRange
///  - Returns: a color of the hour in the day
///
///  - Returns: a legend : an array of ActivityLegendData with the type, the recurency, the total and the unit
struct ActivityRowManager {
    private let data: [ActivityRange]

    init(data: [ActivityRange]) {
        self.data = data
    }

    func color(for hour: Int) -> Color {
        let sortedData = data.sorted { lhs, rhs in
            priority(for: lhs.type) > priority(for: rhs.type)
        }

        for range in sortedData {
            if hour >= range.startHour && hour < range.endHour {
                return range.type.color
            }
        }

        return .gray.mix(with: .white, by: 0.5)
    }

    private func priority(for type: ActivityCategory) -> Int {
        switch type {
        case .food: return 3
        case .diaper: return 2
        case .sleep: return 1
        case .growth: return 0
        }
    }
}

extension ActivityRowManager {
    func generateLegend() -> [ActivityLegendData] {
        var legendData: [ActivityCategory: (recurency: Int, total: Int?, unit: MeasurementSystem?)] = [:]

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
        }.sorted { lhs, rhs in
            priority(for: lhs.type) < priority(for: rhs.type)
        }
    }
}

struct ActivityRange {
    let startHour: Int
    let endHour: Int
    let type: ActivityCategory
    let value: Int?
    let unit: MeasurementSystem?
}
