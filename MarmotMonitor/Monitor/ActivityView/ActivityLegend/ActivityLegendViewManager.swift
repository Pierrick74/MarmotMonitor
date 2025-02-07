//
//  ActivityLegendViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/12/2024.
//

import SwiftUI
/// A manager for handling activity legend data and providing computed properties for the view.
final class ActivityLegendViewManager {

    private let activity: ActivityLegendData
    @ObservedObject private var storageManager: AppStorageManager = AppStorageManager.shared

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

    /// The total value with its appropriate unit, formatted as a string.
    ///
    /// - Returns: A string representing the total value and its unit or `nil` if not applicable.
    var totalValue: String? {
        guard let totalValue = activity.total else { return nil }
        let total = Int(totalValue)
        switch activity.type {
        case .sleep:
            return "\(total) h"
        case .food:
            if storageManager.isMetricUnit == false {
                let total = totalValue / 29.5735
                return "\(total)" + " oz"
            } else {
                return "\(total)" + " ml"
            }

        default:
            return nil
        }
    }

    /// An accessibility  description of the activity label.
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
