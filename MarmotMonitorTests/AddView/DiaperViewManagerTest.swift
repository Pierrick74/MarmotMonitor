//
//  DiaperViewManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 27/11/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

@MainActor
struct DiaperViewManagerTest {
    let dataSource: SwiftDataManagerProtocol
    let dataMock = MockActivities()
    var babyActivity: [BabyActivity] = []
    var manager: DiaperAddViewManager

    @MainActor
    init() {
        dataSource = SwiftDataManager(isStoredInMemoryOnly: true)
        manager = DiaperAddViewManager(dataManager: dataSource)
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

    // MARK: - Color tests
    @Test func testDiaperColor_WhenWetAndDirty_ThenReturnMixedColors() throws {
        // 1. given
        manager.isWet = true
        manager.isDirty = true

        // 2. when
        let color = manager.diaperColor

        // 3. then
        #expect(color == [Color.yellow, Color(uiColor: .diaperButton), Color(.lightGray)])
    }

    @Test func testDiaperColor_WhenOnlyWet_ThenReturnYellowAndGray() {
        // 1. given
        manager.isWet = true
        manager.isDirty = false

        // 2. when
        let color = manager.diaperColor

        // 3. then
        #expect(color == [Color.yellow, Color(.lightGray)])
    }

    @Test func testDiaperColor_WhenOnlyDirty_ThenReturnBrownAndGray() {
        // 1. given
        manager.isWet = false
        manager.isDirty = true

        // 2. when
        let color = manager.diaperColor

        // 3. then
        #expect(color == [Color(uiColor: .diaperButton), Color(.lightGray)])
    }

    @Test func testDiaperColor_WhenNoDataSet_ThenReturnGray() {
        // 1. given
        manager.isWet = false
        manager.isDirty = false

        // 2. when
        let color = manager.diaperColor

        // 3. then
        #expect(color == [Color(.lightGray)])
    }

    // MARK: - Accessibility hint tests
    @Test func testDiaperColor_WhenDateisSet_ThenReturnFormattedString() {
        // 1. given
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr_FR") // Forcer la locale française
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short

        let date = Date(timeIntervalSince1970: 0)
        manager.date = date

        // 2. when
        let hint = manager.accessibilityHintForDate

        // 3. then
        #expect(hint == "1 Jan 1970 at 01:00")
    }

    @Test func testDiaperColor_WhenNoDateisSet_ThenReturnFormattedString() {
        // 1. given
        manager.date = nil

        // 2. when
        let hint = manager.accessibilityHintForDate

        // 3. then
        #expect(hint.isEmpty)
    }

    // MARK: - Save Diaper tests
    @Test mutating func testManagerHaveDiaper_WhenDiaperIsSave_ThenDataisSave() {
        // 1. given
        manager.isWet = true
        manager.isDirty = true
        manager.date = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveDiaper()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
    }

    @Test mutating func testManagerHaveDiaperWet_WhenDiaperIsSave_ThenDataisSave() {
        // 1. given
        manager.isWet = true
        manager.isDirty = false
        manager.date = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveDiaper()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
    }

    @Test mutating func testManagerHaveDiaperDirty_WhenDiaperIsSave_ThenDataisSave() {
        // 1. given
        manager.isWet = false
        manager.isDirty = true
        manager.date = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)

        // 2. when
        manager.saveDiaper()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
    }

    @Test mutating func testManagerHaveNoDiaper_WhenDiaperIsSave_ThenDataisNoSave() {
        // 1. given
        manager.isWet = false
        manager.isDirty = false
        manager.date = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)
        #expect(manager.alertMessage == "Erreur inconnue")

        // 2. when
        manager.saveDiaper()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == true)
        #expect(manager.alertMessage == "Veuillez sélectionner un état de couche")
    }

    @Test mutating func testManagerHaveDiaperSave_WhenDiaperIsSaveAgain_ThenDataisNoSave() {
        // 1. given
        manager.isWet = true
        manager.isDirty = false
        manager.date = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)
        #expect(manager.alertMessage == "Erreur inconnue")
        manager.saveDiaper()
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.saveDiaper()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.isSaveError == true)
        #expect(manager.alertMessage == "Une activité est déja enregistrée à cette date")
    }

    @Test mutating func testManagerHaveDiaperSave_WhenDiaperIsSave55Second_ThenDataisNoSave() {
        // 1. given
        manager.isWet = true
        manager.isDirty = false
        manager.date = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)
        #expect(manager.alertMessage == "Erreur inconnue")
        manager.saveDiaper()
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.date = Date(timeIntervalSince1970: 55)
        manager.saveDiaper()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 1)
        #expect(manager.isSaveError == true)
        #expect(manager.alertMessage == "Une activité est déja enregistrée à cette date")
    }

    @Test mutating func testManagerHaveDiaperSave_WhenDiaperIsSave61Second_ThenDataisNoSave() {
        // 1. given
        manager.isWet = true
        manager.isDirty = false
        manager.date = Date(timeIntervalSince1970: 0)
        #expect(babyActivity.isEmpty)
        #expect(manager.isSaveError == false)
        #expect(manager.alertMessage == "Erreur inconnue")
        manager.saveDiaper()
        updateBabyActivity()
        #expect(babyActivity.count == 1)

        // 2. when
        manager.date = Date(timeIntervalSince1970: 61)
        manager.saveDiaper()
        updateBabyActivity()

        // 3. then
        #expect(babyActivity.count == 2)
        #expect(manager.isSaveError == false)
        #expect(manager.alertMessage == "Erreur inconnue")
    }
}
