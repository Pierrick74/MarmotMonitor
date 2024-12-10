//
//  ActivityLegendViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/12/2024.
//

import SwiftUI

final class ActivityLegendViewManager {

    private var activity: ActivityLegendData

    init(activity: ActivityLegendData) {
        self.activity = activity
    }

    var name: String {
        return activity.type.rawValue
    }

    var color: Color {
        activity.type.color
    }

    var recurency: String {
        "\(activity.recurency) fois"
    }

    var totalValue: String? {
        switch activity.type {
        case .sleep:
            return activity.total != nil ? "\(activity.total!) h" : nil
        case .food:
            let unit = activity.unit == .imperial ? "oz" : "ml"
            return activity.total != nil ? "\(activity.total!)" + " " + unit : nil
        default:
            return nil
        }
    }
}

struct ActivityLegendData: Equatable {
    var type: ActivityCategory
    var recurency: Int
    var total: Double?
    var unit: MeasurementSystem?
}
