//
//  BottleViewAddManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 29/11/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

@MainActor
struct BottleViewAddManagerTest {
    var appStorageManager: AppStorageManagerProtocol
    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: BottleAddViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = BottleAddViewManager(dataManager: dataSource)
        appStorageManager = MockAppStorageManager()
        updateBabyActivity()
    }

    mutating func updateBabyActivity() {
        babyActivity = dataSource.fetchData()
    }

    // MARK: - Bottle range tests
    @Test func testRange_WhenInit_ThenReturnPastToNow() {
        // 1. given

        // 2. when
        let range = manager.range

        // 3. then
        #expect(range.lowerBound == Date.distantPast)
        #expect(range.upperBound > Date.now.addingTimeInterval(-11))
        #expect(range.upperBound < Date.now.addingTimeInterval(11))
    }

    // MARK: - Bottle setPercent tests
    @Test func test_WhenSetPercent_ThenPercentIsSet() {
        // 1. given
        let oldPercent = manager.percent
        // 2. when
        manager.setPercent(50)

        // 3. then
        let newPercent = manager.percent
        #expect(oldPercent != newPercent)
        #expect(newPercent == 50)
    }

    @Test func test_WhenSetPercent_ThenVolumeIsModifie() {
        // 1. given

        let oldVolume = manager.volumeInformation
        // 2. when
        manager.setPercent(50)

        // 3. then
        let newVolume = manager.volumeInformation
        #expect(oldVolume != newVolume)
        #expect(newVolume == "180 ml")
    }

    @Test mutating func testInImperialUnit_WhenSetPercent_ThenVolumeIsModifie() {
        // 1. given
        manager = BottleAddViewManager(dataManager: dataSource, storageManager: MockAppStorageManagerInImperial())
        let oldVolume = manager.volumeInformation
        // 2. when
        manager.setPercent(50)

        // 3. then
        let newVolume = manager.volumeInformation
        #expect(oldVolume != newVolume)
        #expect(newVolume == "180 oz")
    }

    // MARK: - Bottle save tests
    @Test mutating func testManagerHaveBottle_WhenBottleIsSave_ThenDataIsSave() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.setPercent(50)
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveBottle()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
    }

    @Test mutating func testManagerHaveBottle_WhenBottleIsSave_ThenDataIsSaveWithCorrectVolume() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.setPercent(50)
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveBottle()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        switch babyActivity.first?.activity {
        case .bottle(let volume, _):
            #expect(volume == 180)
        default:
            #expect(Bool(false))
        }
    }

    @Test mutating func testManagerHaveNoBottle_WhenBottleIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.date = nil
        manager.setPercent(50)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)

        // 2. when
        manager.saveBottle()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.isSaveError == false)
    }

    @Test mutating func testManagerHaveNoVolume_WhenBottleIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.setPercent(0)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)

        // 2. when
        manager.saveBottle()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == true)
    }

    @Test mutating func testManagerHaveBootle_WhenNewBottleIsSaveAtSameDate_ThenDataIsNotSave() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.setPercent(50)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)
        manager.saveBottle()
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.saveBottle()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.isSaveError == true)
    }

    // MARK: - Bottle increase tests
    @Test mutating func test_WhenIncrease_ThenVolumeIsIncrease() {
        // 1. given
        let oldVolume = manager.volume

        // 2. when
        manager.incrementVolume()

        // 3. then
        let newVolume = manager.volume
        #expect(oldVolume != newVolume)
        #expect(newVolume == oldVolume + 10)
    }

    @Test mutating func testVolumeIsMaxVolume_WhenIncrease_ThenVolumeIsMax() {
        // 1. given
        manager.volume = 360

        // 2. when
        manager.incrementVolume()

        // 3. then
        let newVolume = manager.volume
        #expect(newVolume == 360)
    }

    // MARK: - Bottle decrement tests
    @Test mutating func test_WhenDecrease_ThenVolumeIsDecrease() {
        // 1. given
        let oldVolume = manager.volume

        // 2. when
        manager.decrementVolume()

        // 3. then
        let newVolume = manager.volume
        #expect(oldVolume != newVolume)
        #expect(newVolume == oldVolume - 10)
    }

    @Test mutating func testVolumeIsMaxVolume_WhenDecrease_ThenVolumeIsMin() {
        // 1. given
        manager.volume = 0

        // 2. when
        manager.decrementVolume()

        // 3. then
        let newVolume = manager.volume
        #expect(newVolume == 0)
    }
}
