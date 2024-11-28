//
//  SleepViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 27/11/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

@MainActor
struct SleepViewManagerTest {
    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: SleepAddViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = SleepAddViewManager(dataManager: dataSource)
        updateBabyActivity()
    }

    mutating func updateBabyActivity() {
        babyActivity = dataSource.fetchData()
    }

    // MARK: - Start Hint tests
    @Test func testSleepHasNoDate_When_ThenAcessibilityHintIsEmpty() throws {
        // 1. given
        #expect(manager.startDate == nil)

        // 2. when

        // 3. then
        #expect(manager.accessibilityHintForStartDate == "Valeur Non définie")
    }

    @Test func testSleepHasDate_When_ThenAcessibilityHintIsNotEmpty() {
        // 1. given
        manager.startDate = Date(timeIntervalSince1970: 0)

        // 2. when

        // 3. then
        #expect(manager.accessibilityHintForStartDate == "Heure actuelle : 1 Jan 1970 at 1:00")
    }

    @Test func testSleepHasNoEndDate_When_ThenAcessibilityHintIsEmpty() throws {
        // 1. given
        #expect(manager.endDate == nil)

        // 2. when

        // 3. then
        #expect(manager.accessibilityHintForEndDate == "Valeur Non définie")
    }

    @Test func testSleepHasEndDate_When_ThenAcessibilityHintIsNotEmpty() {
        // 1. given
        manager.endDate = Date(timeIntervalSince1970: 0)

        // 2. when

        // 3. then
        #expect(manager.accessibilityHintForEndDate == "Heure actuelle : 1 Jan 1970 at 1:00")
    }

    // MARK: - Range tests
    @Test func testEndRange_WhenStartDateIsNil_ThenRangeIsNil() {
        // 1. given
        manager.startDate = nil

        // 2. when

        // 3. then
        #expect(manager.endRange == nil)
    }

    @Test func testEndRange_WhenStartDateIsSet_ThenRangeIsCorrect() {
        // 1. given
        manager.startDate = Date(timeIntervalSince1970: 0)

        // 2. when

        // 3. then
        let startDateRange = Date(timeIntervalSince1970: 0).addingTimeInterval(60)
        #expect(manager.endRange == startDateRange...Date.distantFuture)
    }

    @Test func testStartRange_WhenEndDateIsNotSet_ThenRangeIsCorrect() {
        // 1. given
        manager.endDate = nil

        // 2. when

        // 3. then
        let startRange = manager.startRange
        #expect(startRange.lowerBound == Date.distantPast)
        #expect(startRange.upperBound > Date.now.addingTimeInterval(-11))
        #expect(startRange.upperBound < Date.now.addingTimeInterval(11))
    }

    @Test func testStartRange_WhenEndDateIstSet_ThenRangeIsCorrect() {
        // 1. given
        let date = Date(timeIntervalSince1970: 0)
        manager.endDate = date

        // 2. when

        // 3. then
        let startRange = manager.startRange
        #expect(startRange.lowerBound == Date.distantPast)
        #expect(startRange.upperBound == date.addingTimeInterval(-60))
    }
    // MARK: - Save Sleep tests
    @Test mutating func testManagerHaveSleep_WhenSleepIsSave_ThenDataIsSave() {
        // 1. given
        manager.endDate = Date(timeIntervalSince1970: 120)
        manager.startDate = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveSleep()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
    }

    @Test mutating func testManagerHaveNoSleep_WhenSleepIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.endDate = nil
        manager.startDate = nil
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)

        // 2. when
        manager.saveSleep()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == true)
    }

    @Test mutating func testManagerHaveNoEndDate_WhenSleepIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.endDate = nil
        manager.startDate = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)

        // 2. when
        manager.saveSleep()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == true)
    }

    @Test mutating func testManagerHaveNoStartDate_WhenSleepIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.endDate = Date(timeIntervalSince1970: 0)
        manager.startDate = nil
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)

        // 2. when
        manager.saveSleep()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == true)
    }

    @Test mutating func testManagerHaveNoStartDateAndEndDate_WhenSleepIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.endDate = nil
        manager.startDate = nil
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)

        // 2. when
        manager.saveSleep()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == true)
        #expect(manager.alertMessage == "Veuillez sélectionner une date de début et de fin")
    }

    @Test mutating func testManagerHaveData_WhenSleepIsSaveInSameTime_ThenDataIsNotSave() {
        // 1. given
        manager.endDate = Date(timeIntervalSince1970: 120)
        manager.startDate = Date(timeIntervalSince1970: 0)
        manager.saveSleep()
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.saveSleep()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.isSaveError == true)
        #expect(manager.alertMessage == "Activité Sommeil déja présente dans cette plage horraire")
    }
}
