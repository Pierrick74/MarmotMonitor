//
//  SwiftDataManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 20/11/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

struct SwiftDataManagerTest {
    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        updateBabyActivity()
    }

    mutating func updateBabyActivity() {
        babyActivity = dataSource.fetchData()
    }

    @MainActor @Test
    mutating func managerIsSet_whenAddActivity_thenActivityIsAdd() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        dataSource.addActivity(activity: dataMock.oneSleepBabyActivity)
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
    }

    @MainActor @Test
    mutating func managerIsSet_whenRemoveActivity_thenActivityIsremoved() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        dataSource.addActivity(activity: dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)
        dataSource.deleteActivity(activity: dataMock.oneSleepBabyActivity)
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
    }

    @MainActor @Test
    mutating func managerHaveActivity_whenActivityIsFetch_thenlastestActivityIsFirst() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        dataSource.addActivity(activity: dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)
        // 2. when

        dataSource.addActivity(activity: dataMock.sleepBabyActivityBefore)
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 2)
    }

    @MainActor @Test
    mutating func whenAddDifferentAcivities_thenActivityIsSave() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        dataSource.addActivity(activity: dataMock.oneSleepBabyActivity)
        dataSource.addActivity(activity: dataMock.oneSolidBabyActivity)
        dataSource.addActivity(activity: dataMock.oneBottleBabyActivity)
        dataSource.addActivity(activity: dataMock.oneBreastBabyActivity)
        dataSource.addActivity(activity: dataMock.oneDiaperBabyActivity)
        dataSource.addActivity(activity: dataMock.oneGrowthBabyActivity)

        // 3. then
        updateBabyActivity()
        #expect(babyActivity.count == 6)
    }

    @MainActor @Test
    mutating func managerHaveDifferentActivities_whenfetchSleepOnly_thenresultIsSleep() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        dataSource.addActivity(activity: dataMock.oneSleepBabyActivity)
        dataSource.addActivity(activity: dataMock.oneSolidBabyActivity)
        dataSource.addActivity(activity: dataMock.oneBottleBabyActivity)
        dataSource.addActivity(activity: dataMock.oneBreastBabyActivity)
        dataSource.addActivity(activity: dataMock.oneDiaperBabyActivity)
        dataSource.addActivity(activity: dataMock.oneGrowthBabyActivity)

        // 3. then
        babyActivity = dataSource.fetchFilteredActivities(selectedActivityTypes: [ActivityCategory.sleep.rawValue])
        #expect(babyActivity.count == 1)
    }

    @MainActor @Test
    mutating func managerHaveDifferentActivities_whenfetchSleepAndDiaper_thenresultIsSleepAndDiaper() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        dataSource.addActivity(activity: dataMock.oneSleepBabyActivity)
        dataSource.addActivity(activity: dataMock.oneSolidBabyActivity)
        dataSource.addActivity(activity: dataMock.oneBottleBabyActivity)
        dataSource.addActivity(activity: dataMock.oneBreastBabyActivity)
        dataSource.addActivity(activity: dataMock.oneDiaperBabyActivity)
        dataSource.addActivity(activity: dataMock.oneGrowthBabyActivity)

        // 3. then
        babyActivity = dataSource.fetchFilteredActivities(selectedActivityTypes: [ActivityCategory.sleep.rawValue, ActivityCategory.diaper.rawValue])
        #expect(babyActivity.count == 2)
    }

    @MainActor @Test
    mutating func managerHaveDifferentActivities_whenClear_thenDataIsEmpty() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        dataSource.addActivity(activity: dataMock.oneSleepBabyActivity)
        dataSource.addActivity(activity: dataMock.oneSolidBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 2)

        // 2. when
        dataSource.clearAllData()

        // 3. then
        updateBabyActivity()
        #expect(babyActivity.isEmpty)
    }
}
