//
//  MockRanges.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 09/12/2024.
//

import Foundation
@testable import MarmotMonitor

class MockRanges {
    let oneDateSleepOf4Hoursbetween1and5 = [
        ActivityRange(startHour: 1, endHour: 5, type: .sleep, value: 4, unit: .metric)
    ]

    let manyDateInSameRange = [
        ActivityRange(startHour: 1, endHour: 6, type: .sleep, value: 4, unit: .metric),
        ActivityRange(startHour: 2, endHour: 5, type: .diaper, value: nil, unit: .metric),
        ActivityRange(startHour: 2, endHour: 4, type: .food, value: 4, unit: .metric),
        ActivityRange(startHour: 18, endHour: 25, type: .sleep, value: 4, unit: .metric)
    ]
}
