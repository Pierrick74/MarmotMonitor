//
//  MockActivityLegendData.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 09/12/2024.
//

import Foundation
@testable import MarmotMonitor

class MockActivityLegendData {
    // MARK: - Sleep Activities
    let sleep = ActivityLegendData(type: .sleep, recurency: 5, total: 10)
    let diaper = ActivityLegendData(type: .diaper, recurency: 5, total: 10)
    let food = ActivityLegendData(type: .food, recurency: 5, total: 10)
    let foodImperial = ActivityLegendData(type: .food, recurency: 5, total: 10, unit: .imperial)
    let foodWithNoValue = ActivityLegendData(type: .food, recurency: 5, total: nil)
}
