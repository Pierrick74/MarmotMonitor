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
        guard let totalValue = activity.total else { return nil }
        let total = Int(totalValue)
        switch activity.type {
        case .sleep:
            return "\(total) h"
        case .food:
            let unit = activity.unit == .imperial ? "oz" : "ml"
            return "\(total)" + " " + unit
        default:
            return nil
        }
    }

    var accessibilityDescription: String {
        let total = totalValue != nil ? " avec un total de \(totalValue!)" : ""
        return "Activité \(name) répétée \(recurency)" + total
    }
}

struct ActivityLegendData: Equatable {
    var type: ActivityCategory
    var recurency: Int
    var total: Double?
    var unit: MeasurementSystem?
}
