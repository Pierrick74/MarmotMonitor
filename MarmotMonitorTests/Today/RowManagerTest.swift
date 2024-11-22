//
//  RowManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 22/11/2024.
//

import Testing
import SwiftUI
@testable import MarmotMonitor

struct RowManagerTest {
    let dataMock = MockActivities()

    // MARK: - Tests no Activity
    @Test mutating func whenInitSleepManagerWithNoActivity_thenRowIsInDéfaultMode() async throws {
        // 1. when
        let manager = RowManager(babyActivity: nil, category: .sleep)

        // 2. then
        #expect(manager.title == "Sommeil")
        #expect(manager.lastActivity == "Aucune activité renseignée")
        #expect(manager.information.isEmpty)
        #expect(manager.accessibilityDescription == "Sommeil Aucune activité renseignée ")
        #expect(manager.imageName == "Sommeil")
    }

    @Test mutating func whenInitDiaperManagerWithNoActivity_thenRowIsInDéfaultMode() async throws {
        // 1. when
        let manager = RowManager(babyActivity: nil, category: .diaper)

        // 2. then
        #expect(manager.title == "Couche")
        #expect(manager.lastActivity == "Aucune activité renseignée")
        #expect(manager.information.isEmpty)
        #expect(manager.accessibilityDescription == "Couche Aucune activité renseignée ")
        #expect(manager.imageName == "Couche")
    }

    @Test mutating func whenInitFoodManagerWithNoActivity_thenRowIsInDéfaultMode() async throws {
        // 1. when
        let manager = RowManager(babyActivity: nil, category: .food)

        // 2. then
        #expect(manager.title == "Repas")
        #expect(manager.lastActivity == "Aucune activité renseignée")
        #expect(manager.information.isEmpty)
        #expect(manager.accessibilityDescription == "Repas Aucune activité renseignée ")
        #expect(manager.imageName == "Repas")
    }

    @Test mutating func whenInitGrothManagerWithNoActivity_thenRowIsInDéfaultMode() async throws {
        // 1. when
        let manager = RowManager(babyActivity: nil, category: .growth)

        // 2. then
        #expect(manager.title == "Croissance")
        #expect(manager.lastActivity == "Aucune activité renseignée")
        #expect(manager.information.isEmpty)
        #expect(manager.accessibilityDescription == "Croissance Aucune activité renseignée ")
        #expect(manager.imageName == "Croissance")
    }

    // MARK: - Tests lastActivity
    @Test func whenInitWithNowActivity_thenLastActivityIsNow() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.nowActivity, category: .growth)

        // 2. then
        #expect(manager.lastActivity == "Maintenant")
    }

    @Test func whenInitWithOnDayActivity_thenLastActivityIsOneDay() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneDayActivity, category: .growth)

        // 2. then
        #expect(manager.lastActivity == "Il y a 1 jour")
    }

    @Test func whenInitWithTwoDayActivity_thenLastActivityIsTwoDay() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.twoDaysActivity, category: .growth)

        // 2. then
        #expect(manager.lastActivity == "Il y a 2 jours")
    }

    @Test func whenInitWithOneHourActivity_thenLastActivityIsOneHour() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneHourActivity, category: .growth)

        // 2. then
        #expect(manager.lastActivity == "Il y a 1 h")
    }

    @Test func whenInitWithTwoHourActivity_thenLastActivityIsTwoHour() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.twoHoursActivity, category: .growth)

        // 2. then
        #expect(manager.lastActivity == "Il y a 2 h")
    }

    @Test func whenInitWithOneMinuteActivity_thenLastActivityIsOneMinute() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneMinuteActivity, category: .growth)

        // 2. then
        #expect(manager.lastActivity == "Il y a 1 minute")
    }

    @Test func whenInitWithTwoMinuteActivity_thenLastActivityIsTwoMinute() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.twoMinutesActivity, category: .growth)

        // 2. then
        #expect(manager.lastActivity == "Il y a 2 minutes")
    }

    @Test func whenInitWithOneHourAndHalfActivity_thenLastActivityIsOneHourAndHalf() {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneHourAndAndHalfActivity, category: .sleep)

        // 2. then
        #expect(manager.lastActivity == "Il y a 1 h 30 min")
    }

    // MARK: - Tests information
    @Test mutating func whenInitWithActivitySleep_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneSleepBabyActivity, category: .sleep)

        // 2. then
        #expect(manager.information == "40\nmin")
    }

    @Test mutating func whenInitWithActivitySleepOneHrAndHalf_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneHourAndAndHalfActivity, category: .sleep)

        // 2. then
        #expect(manager.information == "1 h\n30 min")
    }

    @Test mutating func whenInitWithActivityDiaper_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneDiaperBabyActivity, category: .sleep)

        // 2. then
        #expect(manager.information == "Urine")
    }

    @Test mutating func whenInitWithActivityBootle_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneBottleBabyActivity, category: .food)

        // 2. then
        #expect(manager.information == "120\nml")
    }

    @Test mutating func whenInitWithActivityBreast_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneBreastBabyActivity, category: .food)

        // 2. then
        #expect(manager.information.isEmpty)
    }

    @Test mutating func whenInitWithActivityFood_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneSolidBabyActivity, category: .food)

        // 2. then
        #expect(manager.information.isEmpty)
    }

    @Test mutating func whenInitWithActivityGrowth_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneGrowthBabyActivity, category: .growth)

        // 2. then
        #expect(manager.information == "9 kg\n70 cm")
    }

    // MARK: - Tests Imperial Unit
    @Test mutating func whenInitWithActivityBootleAndImperialUnit_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneBottleBabyActivityImperial, category: .food)

        // 2. then
        #expect(manager.information == "4\noz")
    }

    @Test mutating func whenInitWithActivityGrowthAndImperialUnit_thenInformationIsDescription() async throws {
        // 1. when
        let manager = RowManager(babyActivity: dataMock.oneGrowthBabyActivityImperial, category: .growth)

        // 2. then
        #expect(manager.information == "6 lbs\n6 in")
    }
}
