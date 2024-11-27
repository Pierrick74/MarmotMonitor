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

//    // MARK: - Color tests
//    @Test func testDiaperColor_WhenWetAndDirty_ThenReturnMixedColors() throws {
//        // 1. given
//        manager.isWet = true
//        manager.isDirty = true
//
//        // 2. when
//        let color = manager.diaperColor
//
//        // 3. then
//        #expect(color == [Color.yellow, Color(uiColor: .diaperButton), Color(.lightGray)])
//    }

}
