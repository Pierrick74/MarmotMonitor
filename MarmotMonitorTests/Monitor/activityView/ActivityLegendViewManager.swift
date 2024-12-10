//
//  ActivityLegendViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 09/12/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

struct ActivityLegendViewManagerTest {

    // MARK: - Color tests
    @Test mutating func testSleep_WhenAddSleepData_ThenDataShowIsSleep() {
        // 1. given
        let manager = ActivityLegendViewManager(activity: MockActivityLegendData().sleep)
        // 2. when

        // 3. then
        #expect(manager.name == "Sommeil")
        #expect(manager.color == ActivityCategory.sleep.color)
        #expect(manager.recurency == "5 fois")
        #expect(manager.totalValue == "10 h")
    }

    @Test mutating func testDiaper_WhenAddDiaperData_ThenDataShowIsDiaper() {
        // 1. given
        let manager = ActivityLegendViewManager(activity: MockActivityLegendData().diaper)
        // 2. when

        // 3. then
        #expect(manager.name == "Couche")
        #expect(manager.color == ActivityCategory.diaper.color)
        #expect(manager.recurency == "5 fois")
        #expect(manager.totalValue == nil)
    }

    @Test mutating func testFood_WhenAddFoodData_ThenDataShowIsFood() {
        // 1. given
        let manager = ActivityLegendViewManager(activity: MockActivityLegendData().food)
        // 2. when

        // 3. then
        #expect(manager.name == "Repas")
        #expect(manager.color == ActivityCategory.food.color)
        #expect(manager.recurency == "5 fois")
        #expect(manager.totalValue == "10 ml")
    }

    @Test mutating func testFood_WhenAddFoodDataImperial_ThenDataShowIsFood() {
        // 1. given
        let manager = ActivityLegendViewManager(activity: MockActivityLegendData().foodImperial)
        // 2. when

        // 3. then
        #expect(manager.name == "Repas")
        #expect(manager.color == ActivityCategory.food.color)
        #expect(manager.recurency == "5 fois")
        #expect(manager.totalValue == "10 oz")
    }

    @Test mutating func testFood_WhenAddFoodDataWithNoValue_ThenDataShowIsFood() {
        // 1. given
        let manager = ActivityLegendViewManager(activity: MockActivityLegendData().foodWithNoValue)
        // 2. when

        // 3. then
        #expect(manager.name == "Repas")
        #expect(manager.color == ActivityCategory.food.color)
        #expect(manager.recurency == "5 fois")
        #expect(manager.totalValue == nil)
    }
}
