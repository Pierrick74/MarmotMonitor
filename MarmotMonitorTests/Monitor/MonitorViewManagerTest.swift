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
    }
}
