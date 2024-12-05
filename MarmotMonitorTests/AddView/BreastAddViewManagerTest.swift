//
//  BreastAddViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 04/12/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

@MainActor
struct BreastAddViewManagerTest {
    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: BreastAddViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = BreastAddViewManager(dataManager: dataSource)
        updateBabyActivity()
    }

    mutating func updateBabyActivity() {
        babyActivity = dataSource.fetchData()
    }

    // MARK: - Diaper range tests
    @Test func testRange_WhenInit_ThenReturnPastToNow() {
        // 1. given

        // 2. when
        let range = manager.range

        // 3. then
        #expect(range.lowerBound == Date.distantPast)
        #expect(range.upperBound > Date.now.addingTimeInterval(-11))
        #expect(range.upperBound < Date.now.addingTimeInterval(11))
    }

    // MARK: - TotalTime tests
    @Test func testTotalTime_WhenInit_ThenReturnZero() {
        // 1. given

        // 2. when
        let totalTime = manager.totalTime

        // 3. then
        #expect(totalTime == "00:00")
    }

    @Test func testTotalTime_WhenStartIsCalled_ThenReturnCorrectValue() {
        // 1. given
        manager.timerLeft.timeElapsed = 200
        manager.timerRight.timeElapsed = 200

        // 2. when
        let totalTime = manager.totalTime

        // 3. then
        #expect(totalTime == "06:40")
    }

    // MARK: - Breast save tests
    @Test mutating func testManager_WhenBreastIsSave_ThenDataIsSave() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.timerLeft.timeElapsed = 200
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveBreast()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        if case let .breast(duration, _) = babyActivity.first?.activity {
            #expect(duration.leftDuration == 200)
            #expect(duration.rightDuration == 0)
        } else {
            Issue.record("activity is not breast")
        }
    }

    @Test mutating func testManagerHaveBreastActivity_WhenBreastIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.timerLeft.timeElapsed = 200
        #expect(babyActivity.isEmpty)
        manager.saveBreast()
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.saveBreast()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.isSaveError == true)
    }

    // MARK: - checkFirstBreast information
    @Test mutating func testNoTimerElapsed_WhenCheckLeft_ThenfirstBrestLeft() {
        // 1. given
        manager.timerLeft.timeElapsed = 0
        manager.timerRight.timeElapsed = 0
        manager.firstBreast = .right

        // 2. when
        manager.checkFirstBreast(at: .left)

        // 3. then
        #expect(manager.firstBreast == .left)
    }

    @Test mutating func testNoTimerElapsed_WhenCheckRight_ThenfirstBrestRight() {
        // 1. given
        manager.timerLeft.timeElapsed = 0
        manager.timerRight.timeElapsed = 0
        manager.firstBreast = .left

        // 2. when
        manager.checkFirstBreast(at: .right)

        // 3. then
        #expect(manager.firstBreast == .right)
    }

    @Test mutating func testTimerLeftHaveElapsed_WhenCheckRight_ThenfirstNoChange() {
        // 1. given
        manager.timerLeft.timeElapsed = 5
        manager.timerRight.timeElapsed = 0
        manager.firstBreast = .left

        // 2. when
        manager.checkFirstBreast(at: .right)

        // 3. then
        #expect(manager.firstBreast == .left)
    }

    @Test mutating func testTimerRightHaveElapsed_WhenCheckRight_ThenfirstNoChange() {
        // 1. given
        manager.timerLeft.timeElapsed = 0
        manager.timerRight.timeElapsed = 5
        manager.firstBreast = .left

        // 2. when
        manager.checkFirstBreast(at: .right)

        // 3. then
        #expect(manager.firstBreast == .right)
    }

    @Test mutating func testTimerRightHaveElapsed_WhenCheckLeft_ThenfirstNoChange() {
        // 1. given
        manager.timerLeft.timeElapsed = 0
        manager.timerRight.timeElapsed = 1
        manager.firstBreast = .right

        // 2. when
        manager.checkFirstBreast(at: .left)

        // 3. then
        #expect(manager.firstBreast == .right)
    }

    @Test mutating func testTimerLeftHaveElapsed_WhenCheckLeft_ThenfirstNoChange() {
        // 1. given
        manager.timerLeft.timeElapsed = 5
        manager.timerRight.timeElapsed = 0
        manager.firstBreast = .right

        // 2. when
        manager.checkFirstBreast(at: .left)

        // 3. then
        #expect(manager.firstBreast == .left)
    }
}
