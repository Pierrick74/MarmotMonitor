//
//  GrowthViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 21/01/2025.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

@MainActor
struct GrowthViewManagerTest {

    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: GrowthViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = GrowthViewManager(
            appStorageManager: MockAppStorageManager(),
            dataManager: dataSource
        )
        updateBabyActivity()
    }

    mutating func updateBabyActivity() {
        babyActivity = dataSource.fetchData()
    }

    @Test("Title based on selected position",
          arguments: [
            (selection: 0, title: "Taille"),
            (selection: 1, title: "Poids"),
            (selection: 2, title: "Périmètre crânien"),
            (selection: 3, title: "Poids")])
    func testTitle_whenSelectedPositionChanges(selection: Int, title: String) throws {

        // 2. when
        manager.selectedPosition = selection

        // 3. then
        #expect(manager.title == title)
    }

    @Test("Unit based on selected position",
          arguments: [
            (selection: 0, isMetric: true, unit: "en Cm"),
            (selection: 1, isMetric: true, unit: "en Kg"),
            (selection: 2, isMetric: true, unit: "en Cm"),
            (selection: 3, isMetric: true, unit: "en Kg"),
            (selection: 0, isMetric: false, unit: "en In"),
            (selection: 1, isMetric: false, unit: "en Lbs"),
            (selection: 2, isMetric: false, unit: "en In"),
            (selection: 3, isMetric: false, unit: "en Lbs")])
    func testUnit_whenSelectedPositionChanges(selection: Int, isMetric: Bool, unit: String) throws {
        let testManager: GrowthViewManager

        if isMetric == true {
            testManager = GrowthViewManager(
                appStorageManager: MockAppStorageManager(),
                dataManager: dataSource
            )
        } else {
            testManager = GrowthViewManager(
                appStorageManager: MockAppStorageManagerInImperial(),
                dataManager: dataSource)
        }

        // 2. when
        testManager.selectedPosition = selection

        // 3. then
        #expect(testManager.unit == unit)
    }

    @Test("refresh data",
          arguments: [
            (testDate: [Date.now], numberOfActivities: 1, numberOfShowingActivities: 1),
            (testDate: [Date().addingTimeInterval(2929800), Date.now], numberOfActivities: 2, numberOfShowingActivities: 2),
            (testDate: [Date().addingTimeInterval(86405), Date.now], numberOfActivities: 2, numberOfShowingActivities: 1)])
    mutating func testRefrechData_whenDataChanges(testDate: [Date], numberOfActivities: Int, numberOfShowingActivities: Int) throws {

        for date in testDate {
            let element = BabyActivity(activity: .growth(data: GrowthData(weight: 9.2, height: 70, headCircumference: 45)), date: date)
            try dataSource.addActivity(element)
        }
        updateBabyActivity()
        // 2. when
        manager.refreshData()

        // 3. then
        #expect(manager.dataShow.count == numberOfShowingActivities)
        #expect(manager.listData.count == numberOfActivities)
    }

    @Test(
        "delete data",
        arguments: [
            (testDate: [
                    Date().addingTimeInterval(2929800),
                    Date.now
                ],
                numberOfActivities: 2,
                numberOfShowingActivities: 2
            ),
            (testDate: [
                    Date().addingTimeInterval(2929800),
                    Date.now,
                    Date().addingTimeInterval(8000000)
                ],
                numberOfActivities: 3,
                numberOfShowingActivities: 3
            )]
    )
    mutating func testDeleteActivity_whenDataChanges(testDate: [Date], numberOfActivities: Int, numberOfShowingActivities: Int) throws {

        for date in testDate {
            let element = BabyActivity(activity: .growth(data: GrowthData(weight: 9.2, height: 70, headCircumference: 45)), date: date)
            try dataSource.addActivity(element)
        }
        manager.refreshData()
        #expect(manager.dataShow.count == numberOfShowingActivities)
        #expect(manager.listData.count == numberOfActivities)

        // 2. when
        if let activity = manager.listData.last {
            manager.deleteActivity(activity)
        } else {
            #expect(Bool(false), "Activity is nil")
        }

        // 3. then
        #expect(manager.dataShow.count == numberOfShowingActivities - 1)
        #expect(manager.listData.count == numberOfActivities - 1)
    }
}
