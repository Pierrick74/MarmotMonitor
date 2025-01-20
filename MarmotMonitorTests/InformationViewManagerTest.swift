//
//  InformationViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 20/01/2025.
//
import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

struct InformationViewManagerTest {
    let manager = InformationViewManager(dataManager: MockAppStorageManager())

    // MARK: - AddActivity tests
    @Test
    mutating func whenManagerIsSet_thenActivityIsUpdate() throws {

        // 3. then
        #expect(manager.name == "Line")
        #expect(manager.parentName == "Pierrick")
        #expect(manager.gender == .girl)
    }

    @Test
    mutating func whenSetData_thenActivityIsUpdate() throws {
        manager.name = "test"
        manager.parentName = "ParentTest"
        manager.gender = .boy
        let date = Date.now
        manager.babyBirthday = date

        manager.saveInformation()
        // 3. then
        #expect(manager.name == "test")
        #expect(manager.parentName == "ParentTest")
        #expect(manager.gender == .boy)
        #expect(manager.babyBirthday == date)
    }
}
