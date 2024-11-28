//
//  TodayStripNameManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 13/11/2024.
//

import Testing
import SwiftUI
@testable import MarmotMonitor

struct TodayStripNameManagerTest {

    let manager: TodayStripNameManager
    var storage: AppStorageManagerProtocol

    init() {
        storage = MockAppStorageManager()
        manager = TodayStripNameManager(storageManager: storage)
    }

    // MARK: - Tests baby age day
    @Test func whenDateIsInit_thenBabyAgeIsZero() async throws {
        // 1. given
        #expect(manager.babyAge == "0 jour")
    }

    @Test mutating func whenSetBabyAgeOf1_thenDayIsInSingle() async throws {
        // 1. given

        // 2. when
        storage.babyBirthday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        // = Date correspondant à hier à la même heure

        // 3. then
        #expect(manager.babyAge == "1 jour")
    }

    @Test mutating func whenSetBabyAgeOf2_thenDayIsInPluriel() async throws {
        // 1. given

        // 2. when
        storage.babyBirthday = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        // = Date correspondant à hier à la même heure

        // 3. then
        #expect(manager.babyAge == "2 jours")
    }

    // MARK: - Tests baby age day
    @Test mutating func whenSetBabyAgeOf1year_thenDayIsInSingle() async throws {
        // 1. given

        // 2. when
        storage.babyBirthday = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        // = Date correspondant à hier à la même heure

        // 3. then
        #expect(manager.babyAge == "1 an et 0 mois")
    }

    @Test mutating func whenSetBabyAgeOf2year_thenDayIsInPluriel() async throws {
        // 1. given

        // 2. when
        storage.babyBirthday = Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date()

        // 3. then
        #expect(manager.babyAge == "2 ans et 0 mois")
    }

    @Test mutating func whenSetBabyAgeOf2year3Month15Days_thenDayIsInPluriel() async throws {
        // 1. given

        let years = 2 * 12 * 30 * 24 * 60 * 60
        let months = 3 * 30 * 24 * 60 * 60
        let days = 15 * 24 * 60 * 60
        let date = Date(timeIntervalSinceNow: -Double(years + months + days))

        // 2. when
        storage.babyBirthday = date

        // 3. then
        #expect(manager.babyAge == "2 ans et 3 mois")
    }
}
