//
//  GrowthAddViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 06/12/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

@MainActor
struct GrowthAddViewManagerTest {
    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: GrowthAddViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = GrowthAddViewManager(dataManager: dataSource)
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

    @Test func testSizeUnit_ThenReturnMetric() {
        // 1. given

        // 2. when
        let unit = manager.sizeUnit

        // 3. then
        #expect(unit == "cm")
    }

    @Test func testWeightUnit_ThenReturnMetric() {
        // 1. given

        // 2. when
        let unit = manager.weightUnit

        // 3. then
        #expect(unit == "kg")
    }

    // MARK: - height Description tests
    @Test func testHeightDescription_WhenInit_ThenReturnNil() {
        // 1. given
        manager.height = nil

        // 2. when
        let heightDescription = manager.heightDescription

        // 3. then
        #expect(heightDescription == nil)
    }

    @Test func testHeightDescription_WhenSetValue_ThenReturnValue() {
        // 1. given
        manager.height = 5

        // 2. when
        let heightDescription = manager.heightDescription

        // 3. then
        #expect(heightDescription == "5.0 cm")
    }

    // MARK: - height Description tests
    @Test func testWeightDescription_WhenInit_ThenReturnNil() {
        // 1. given
        manager.weight = nil

        // 2. when
        let weightDescription = manager.weightDescription

        // 3. then
        #expect(weightDescription == nil)
    }

    @Test func testWeightDescription_WhenSetValue_ThenReturnValue() {
        // 1. given
        manager.weight = 5

        // 2. when
        let weightDescription = manager.weightDescription

        // 3. then
        #expect(weightDescription == "5.0 kg")
    }

    // MARK: - head Description tests
    @Test func testHeadDescription_WhenInit_ThenReturnNil() {
        // 1. given
        manager.headSize = nil

        // 2. when
        let headDescription = manager.headSizeDescription

        // 3. then
        #expect(headDescription == nil)
    }

    @Test func testHeadDescription_WhenSetValue_ThenReturnValue() {
        // 1. given
        manager.headSize = 5

        // 2. when
        let headDescription = manager.headSizeDescription

        // 3. then
        #expect(headDescription == "5.0 cm")
    }

    // MARK: - isInformation
    @Test func testIsInformation_WhenInit_ThenReturnFalse() {
        // 1. given

        // 2. when
        let isInformation = manager.isInformationToSave

        // 3. then
        #expect(isInformation == false)
    }

    @Test func testIsInformation_WhenSetHeight_ThenReturnTrue() {
        // 1. given
        manager.height = 5
        manager.weight = nil
        manager.headSize = nil

        // 2. when
        let isInformation = manager.isInformationToSave

        // 3. then
        #expect(isInformation == true)
    }

    @Test func testIsInformation_WhenSetWeight_ThenReturnTrue() {
        // 1. given
        manager.height = nil
        manager.weight = 5
        manager.headSize = nil

        // 2. when
        let isInformation = manager.isInformationToSave

        // 3. then
        #expect(isInformation == true)
    }

    @Test func testIsInformation_WhenSetHeadSize_ThenReturnTrue() {
        // 1. given
        manager.height = nil
        manager.weight = nil
        manager.headSize = 5

        // 2. when
        let isInformation = manager.isInformationToSave

        // 3. then
        #expect(isInformation == true)
    }

    // MARK: - Breast save tests
    @Test mutating func testManager_WhenGrothIsSave_ThenDataIsSave() {
        // 1. given
        manager.date = nil
        manager.height = 5
        manager.headSize = 6
        manager.weight = 4
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveGrowth()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        if case let .growth(data) = babyActivity.first?.activity {
            #expect(data.height == 5)
            #expect(data.weight == 4)
            #expect(data.headCircumference == 6)
            #expect(data.measurementSystem == .metric)
        } else {
            Issue.record("activity is not breast")
        }
    }

    @Test mutating func testManagerHaveGrowthActivity_WhenGrowthIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.height = 5
        #expect(babyActivity.isEmpty)
        manager.saveGrowth()
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.saveGrowth()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.isSaveError == true)
    }

    @Test mutating func testManagerHaveNoGrowthActivity_WhenGrowthIsSave_ThenDataIsNotSave() {
        // 1. given
        manager.date = Date(timeIntervalSince1970: 120)
        manager.height = nil
        manager.headSize = nil
        manager.weight = nil
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveGrowth()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == true)
    }}
