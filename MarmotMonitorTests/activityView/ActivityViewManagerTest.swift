//
//  ActivityViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 09/12/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

struct ActivityViewManagerTest {
    var manager = ActivityViewManager(data: MockRanges().oneDateSleepOf4Hoursbetween1and5)

    // MARK: - Color tests
    @Test mutating func testColor_WhenOneData_ThenColorIsPainting() {
        // 1. given
        manager = ActivityViewManager(data: MockRanges().oneDateSleepOf4Hoursbetween1and5)
        // 2. when
        let color0 = manager.color(for: 0)
        let color2 = manager.color(for: 2)
        let color4 = manager.color(for: 4)
        let color5 = manager.color(for: 5)
        let color6 = manager.color(for: 6)

        // 3. then
        #expect(color0 == .white)
        #expect(color2 == .blue)
        #expect(color4 == .blue)
        #expect(color5 == .white)
        #expect(color6 == .white)
    }

    @Test mutating func testDataHaveManyType_WhenCallColor_ColorIsSortedByPriority() {
        // 1. given
        manager = ActivityViewManager(data: MockRanges().manyDateInSameRange)
        // 2. when
        let color0 = manager.color(for: 0)
        let color1 = manager.color(for: 1)
        let color2 = manager.color(for: 2)
        let color3 = manager.color(for: 3)
        let color4 = manager.color(for: 4)
        let color5 = manager.color(for: 5)
        let color6 = manager.color(for: 6)

        // 3. then
        #expect(color0 == .white)
        #expect(color1 == .blue)
        #expect(color2 == .green)
        #expect(color3 == .green)
        #expect(color4 == .yellow)
        #expect(color5 == .blue)
        #expect(color6 == .white)
    }

    // MARK: - Data Legend tests
    @Test mutating func testLegendData_WhenOneData_ThenLegendIsCreated() {
        // 1. given
        manager = ActivityViewManager(data: MockRanges().oneDateSleepOf4Hoursbetween1and5)
        // 2. when
        let legend = manager.generateLegend()

        // 3. then
        #expect(legend == [ActivityLegendData(type: .sleep, recurency: 1, total: 4, unit: .metric)])
    }

    @Test mutating func testLegendData_WhenManyData_ThenLegendIsCreated() {
        // 1. given
        manager = ActivityViewManager(data: MockRanges().manyDateInSameRange)
        // 2. when
        let legend = manager.generateLegend()
        let result = [ActivityLegendData(type: .sleep, recurency: 2, total: 8, unit: .metric),
                      ActivityLegendData(type: .diaper, recurency: 1, total: nil, unit: nil),
                      ActivityLegendData(type: .food, recurency: 1, total: 4, unit: .metric)]

        // 3. then
        #expect(legend == result)
    }
}
