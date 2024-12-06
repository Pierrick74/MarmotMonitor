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

    // MARK: - AddActivity tests
    @MainActor @Test
    mutating func managerIsSet_whenAddActivity_thenActivityIsAdd() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
    }

    @MainActor @Test
    mutating func whenAddDifferentAcivities_thenActivityIsSave() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        try dataSource.addActivity(dataMock.oneBottleBabyActivity)
        try dataSource.addActivity(dataMock.oneBreastBabyActivity)
        try dataSource.addActivity(dataMock.oneDiaperBabyActivity)
        try dataSource.addActivity(dataMock.oneGrowthBabyActivity)

        // 3. then
        updateBabyActivity()
        #expect(babyActivity.count == 5)
    }

    // MARK: - Remove Tests
    @MainActor @Test
    mutating func managerIsSet_whenRemoveActivity_thenActivityIsremoved() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)
        dataSource.deleteActivity(activity: dataMock.oneSleepBabyActivity)
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
    }

    // MARK: - Fetch Tests
    @MainActor @Test
    mutating func managerHaveActivity_whenActivityIsFetch_thenlastestActivityIsFirst() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)
        // 2. when

        try dataSource.addActivity(dataMock.sleepBabyActivityBefore)
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 2)
    }

    // MARK: - Fetch Filtered Tests
    @MainActor @Test
    mutating func managerHaveDifferentActivitiesWithNoSleep_whenfetchSleep_thenresultIsEmpty() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneBottleBabyActivity)
        try dataSource.addActivity(dataMock.oneBreastBabyActivity)
        try dataSource.addActivity(dataMock.oneDiaperBabyActivity)
        try dataSource.addActivity(dataMock.oneGrowthBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 4)

        // 2. when
        babyActivity = dataSource.fetchFilteredActivities(with: [.sleep])

        // 3. then
        #expect(babyActivity.isEmpty)
    }

    @MainActor @Test
    mutating func managerHaveDifferentActivitiesWithNoSleep_whenfetchListeIsEmpty_thenresultIsEmpty() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        babyActivity = dataSource.fetchFilteredActivities(with: [])

        // 3. then
        #expect(babyActivity.isEmpty)
    }

    @MainActor @Test
    mutating func managerHaveDifferentActivities_whenfetchSleepOnly_thenresultIsSleep() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        try dataSource.addActivity(dataMock.oneBottleBabyActivity)
        try dataSource.addActivity(dataMock.oneBreastBabyActivity)
        try dataSource.addActivity(dataMock.oneDiaperBabyActivity)
        try dataSource.addActivity(dataMock.oneGrowthBabyActivity)

        // 3. then
        babyActivity = dataSource.fetchFilteredActivities(with: [.sleep])
        #expect(babyActivity.count == 1)
    }

    @MainActor @Test
    mutating func managerHaveDifferentActivities_whenfetchSleepAndDiaper_thenresultIsSleepAndDiaper() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        try dataSource.addActivity(dataMock.oneBottleBabyActivity)
        try dataSource.addActivity(dataMock.oneBreastBabyActivity)
        try dataSource.addActivity(dataMock.oneDiaperBabyActivity)
        try dataSource.addActivity(dataMock.oneGrowthBabyActivity)

        // 3. then
        babyActivity = dataSource.fetchFilteredActivities(with: [.sleep, .diaper])
        #expect(babyActivity.count == 2)
    }

    @MainActor @Test
    mutating func managerHaveDifferentActivities_whenfetchSleep_thenresultIsSleepWithLastestActivityInFirst() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        try dataSource.addActivity(dataMock.sleepBabyActivityBefore)
        updateBabyActivity()
        #expect(babyActivity.count == 2)

        // 2. when
        babyActivity = dataSource.fetchFilteredActivities(with: [.sleep])

        // 3. then
        #expect(babyActivity.count == 2)
        #expect(babyActivity.first?.date == dataMock.oneSleepBabyActivity.date)
    }

    // MARK: - Clear Tests
    @MainActor @Test
    mutating func managerHaveDifferentActivities_whenClear_thenDataIsEmpty() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        try dataSource.addActivity(dataMock.oneBottleBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 2)

        // 2. when
        dataSource.clearAllData()

        // 3. then
        updateBabyActivity()
        #expect(babyActivity.isEmpty)
    }

    // MARK: - hasSleepActivitOverlapping Tests
    @MainActor @Test
    mutating func managerHaveSleeActivities_whenCheckNewactivityWithConflict_thenActivityOverlappingIsTrue() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        do {
            try dataSource.addActivity(dataMock.sleepBabyActivityBeforeOneHourDuringTwo)
        } catch {
            // 3. then
            #expect(error as? ActivityError == ActivityError.overlappingActivity)
        }
        #expect(babyActivity.count == 1)
    }

    @MainActor @Test
    mutating func managerHaveSleeActivities_whenCheckNewactivityWithNoConflict_thenActivityOverlappingIsFalse() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        do {
            try dataSource.addActivity(dataMock.sleepBabyActivityBefore)
        } catch {
            // 3. then
            #expect(error as? ActivityError == ActivityError.overlappingActivity)
        }
        #expect(babyActivity.count == 1)
    }

    @MainActor @Test
    mutating func managerHaveBeforeSleeActivities_whenCheckNewactivityWithNoConflict_thenActivityOverlappingIsFalse() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.sleepBabyActivityBefore)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        do {
            try dataSource.addActivity(dataMock.oneSleepBabyActivity)
        } catch {
            // 3. then
            #expect(error as? ActivityError == ActivityError.overlappingActivity)
        }
        #expect(babyActivity.count == 1)
    }

    // MARK: - Growth Tests

    @MainActor @Test
    mutating func managerHaveNoActivities_whenSaveGrowthActivity_thenActivitIsSaved() throws {
        // 1. given
        #expect(babyActivity.isEmpty)

        // 2. when
        try dataSource.addActivity(dataMock.oneGrowthBabyActivity)

        // 3. then
        updateBabyActivity()
        #expect(babyActivity.count == 1)
    }

    @MainActor @Test
    mutating func managerHaveGrowthActivities_whenSaveGrowthActivity_thenActivitIsNotSaved() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        try dataSource.addActivity(dataMock.oneGrowthBabyActivity)
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        do {
            try dataSource.addActivity(dataMock.oneGrowthBabyActivity)
        } catch {
            // 3. then
            #expect(error as? ActivityError == ActivityError.overlappingActivity)
        }
        #expect(babyActivity.count == 1)
    }
}
