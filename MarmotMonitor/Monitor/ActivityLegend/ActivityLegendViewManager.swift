//
//  ActivityLegendViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/12/2024.
//

import SwiftUI

final class ActivityLegendViewManager {

    var activity: ActivityLegendData

    init(activity: ActivityLegendData) {
        self.activity = activity
    }

    var name: String {
        return activity.type.rawValue
    }

    var color: Color {
        switch activity.type {
        case .sleep:
            return .blue.mix(with: .white, by: 0.5)
        case .food:
            return .green.mix(with: .white, by: 0.5)
        case .diaper:
            return .yellow.mix(with: .white, by: 0.5)
        case .growth:
            return .purple.mix(with: .white, by: 0.5)
        }
    }

    var recurency: String {
        "\(activity.recurency) fois"
    }

    var totalValue: String? {
        switch activity.type {
        case .sleep:
            return activity.total != nil ? "\(activity.total!) h" : nil
        case .food:
            let unit = activity.unit == .metric ? "ml" : "oz"
            return activity.total != nil ? "\(activity.total!)" + " " + unit : nil
        default:
            return nil
        }
    }
}

struct ActivityLegendData {
    var type: ActivityCategory
    var recurency: Int
    var total: Int?
    var unit: MeasurementSystem?
}
