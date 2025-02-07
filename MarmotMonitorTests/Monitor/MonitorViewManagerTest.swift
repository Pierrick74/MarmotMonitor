//
//  MonitorViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 10/12/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

@MainActor
struct MonitorViewManagerTest {

    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: MonitorViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = MonitorViewManager(dataManager: dataSource)
        updateBabyActivity()
    }

    mutating func updateBabyActivity() {
        babyActivity = dataSource.fetchData()
    }

    @Test mutating func dataHaveSleepActivity_whenCreateRangeActivity_thenresultHaveOneSleepRange() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
       manager.loadActivitiesInDateRange()

        // 3. then
        #expect(manager.formattedActivityData.count == 1)
        if let firstEntry = manager.formattedActivityData.first {
            let date = firstEntry.key
            let activityRanges = manager.formattedActivityData[date]![0]
            #expect(activityRanges.type == .sleep)
//            #expect(activityRanges.endHour == (activityRanges.startHour + 1))
        } else {
            #expect(Bool(false))
        }
    }

    @Test mutating func dataHaveDiaperActivity_whenCreateRangeActivity_thenresultHaveOneDiaperRange() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneDiaperBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.loadActivitiesInDateRange()

        // 3. then
        #expect(manager.formattedActivityData.count == 1)
        if let firstEntry = manager.formattedActivityData.first {
            let date = firstEntry.key
            let activityRanges = manager.formattedActivityData[date]![0]
            #expect(activityRanges.type == .diaper)
            #expect(activityRanges.endHour == activityRanges.startHour + 1)
        } else {
            #expect(Bool(false))
        }
    }

    @Test mutating func dataHaveBottleActivity_whenCreateRangeActivity_thenresultHaveOneBottleRange() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneBottleBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.loadActivitiesInDateRange()

        // 3. then
        #expect(manager.formattedActivityData.count == 1)
        if let firstEntry = manager.formattedActivityData.first {
            let date = firstEntry.key
            let activityRanges = manager.formattedActivityData[date]![0]
            #expect(activityRanges.type == .food)
            #expect(activityRanges.endHour == activityRanges.startHour + 1)
            #expect(activityRanges.value == 120)
        } else {
            #expect(Bool(false))
        }
    }

    @Test mutating func filterAllFilterIsSelected_whenToggleFilterSleep_thenFilterIsNotSelected() throws {
        // 1. given
        #expect(manager.isSleepSelected)

        // 2. when
        manager.toggleFilter(.sleep)

        // 3. then
        #expect(manager.isSleepSelected == false)
        manager.toggleFilter(.sleep)
        #expect(manager.isSleepSelected)
    }

    @Test mutating func filterAllFilterIsSelected_whenToggleFilterDiaper_thenFilterIsNotSelected() throws {
        // 1. given
        #expect(manager.isDiaperSelected)

        // 2. when
        manager.toggleFilter(.diaper)

        // 3. then
        #expect(manager.isDiaperSelected == false)
        manager.toggleFilter(.diaper)
        #expect(manager.isDiaperSelected)
    }

    @Test mutating func filterAllFilterIsSelected_whenToggleFilterFood_thenFilterIsNotSelected() throws {
        // 1. given
        #expect(manager.isFoodSelected)

        // 2. when
        manager.toggleFilter(.food)

        // 3. then
        #expect(manager.isFoodSelected == false)
        manager.toggleFilter(.food)
        #expect(manager.isFoodSelected)
    }
}
