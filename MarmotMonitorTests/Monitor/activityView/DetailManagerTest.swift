//
//  DetailManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 20/01/2025.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

struct DetailManagerTest {
    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: DetailViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = DetailViewManager(dataManager: dataSource, date: Date())
        updateBabyActivity()
    }

    mutating func updateBabyActivity() {
        babyActivity = dataSource.fetchData()
    }

    // MARK: - AddActivity tests
    @MainActor
    @Test(
        "Verify input validator rejects values of growth data",
        arguments: [
            (input: BabyActivity(activity: .sleep(duration: 2400), date: .now), expectedOutput: 1),
            (input: BabyActivity(activity: .diaper(state: .wet), date: .now), expectedOutput: 1),
            (input: BabyActivity(activity: .growth(data: GrowthData(weight: 9.2, height: 70, headCircumference: 45)),
                                 date: .now), expectedOutput: 0)
        ]
    )
    mutating func managerIsSet_whenAddActivity_thenActivityIsAdd(input: BabyActivity, expectedOutput: Int) throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        #expect(manager.formattedActivityData.isEmpty)

        // 2. when
        try dataSource.addActivity(input)
        updateBabyActivity()
        manager.fetchActivityData()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.formattedActivityData.count == expectedOutput)
    }

    @MainActor @Test("Verify delete activity")
    mutating func managerIsSet_whenAddActivity_thenActivityIsAdd() throws {
        // 1. given
        #expect(babyActivity.isEmpty)
        #expect(manager.formattedActivityData.isEmpty)
        let date = Date.now
        let activity = BabyActivity(activity: .sleep(duration: 2400), date: date)

        // 2. when
        try dataSource.addActivity(activity)
        updateBabyActivity()
        manager.fetchActivityData()

        #expect(babyActivity.count == 1)
        #expect(manager.formattedActivityData.count == 1)

        manager.deleteActivity(manager.formattedActivityData[0])
        updateBabyActivity()
        manager.fetchActivityData()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.formattedActivityData.isEmpty)
    }
}
