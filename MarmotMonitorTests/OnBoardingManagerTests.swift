//
//  OnBoardingManagerTests.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 31/10/2024.
//

import Testing
import SwiftUI
@testable import MarmotMonitor

struct OnBoardingManagerTests {
    let manager: OnBoardingManager
    var storage: AppStorageManagerProtocol

    init() {
        storage = MockAppStorageManager()
        manager = OnBoardingManager(storageManager: storage)
    }

    // MARK: - Tests Screen manager
    @Test func whenClassIsInit_thenActicveScreenIsWelcom() async throws {
        // 1. given
        #expect(manager.activeScreen == OnBoardingManager.Screen.allCases.first!.rawValue)
    }

    @Test func whenClassIsInit_thenScreenAvailableIsFive() async throws {
        // 1. given
        #expect(OnBoardingManager.Screen.allCases.count == 5)
    }

    @Test func whenClassIsInit_thenScreenTitleReturnCorrectValue() async throws {
        // 1. given
        #expect(OnBoardingManager.Screen.welcome.title == "Bonjour")
        #expect(OnBoardingManager.Screen.babyName.title == "Nom du bébé")
        #expect(OnBoardingManager.Screen.gender.title == "genre du bébé")
        #expect(OnBoardingManager.Screen.parentName.title == "nom des parents")
        #expect(OnBoardingManager.Screen.birthDate.title == "date de naissance")

    }

    @Test func whenNextIsCall_thenActicveScreenIsIncrement() async throws {
        // 1. given
        let initValue = manager.activeScreen

        // 2. when
        manager.next()

        // 3. then
        #expect(initValue == OnBoardingManager.Screen.allCases.first!.rawValue)
        #expect(manager.activeScreen == OnBoardingManager.Screen.allCases.first!.rawValue + 1)
    }

    @Test func whenNextIsCall_thenShouldNotExceedLastScreen() async throws {
        // 2. when
        for _ in 0...10 {
            manager.next()
        }

        // 3. then
        #expect(manager.activeScreen == OnBoardingManager.Screen.allCases.last!.rawValue)
    }

    @Test func whenPreviousIsCall_thenActicveScreenIsDecrement() async throws {
        // 1. given
        let initValue = manager.activeScreen

        // 2. when
        manager.next()
        manager.previous()

        // 3. then
        #expect(initValue == OnBoardingManager.Screen.allCases.first!.rawValue)
        #expect(manager.activeScreen == OnBoardingManager.Screen.allCases.first!.rawValue)
    }

    @Test func whenPreviousIsCall_thenShouldNotExceedFirstScreen() async throws {
        // 2. when
        for _ in 0...10 {
            manager.previous()
        }

        // 3. then
        #expect(manager.activeScreen == OnBoardingManager.Screen.allCases.first!.rawValue)
    }

    // MARK: - Tests BabyName manager
    @Test func whenBabyNameIsSet_thenBabyNameIsSaved() async throws {
        // 1. given
        let babyName = "BabyName"

        // 2. when
        manager.babyName = babyName

        // 3. then
        #expect(storage.babyName == babyName)
        #expect(manager.babyName == babyName)
    }

    @Test mutating func babyNameHaveValueInStorage_WhenBabyNameIsGet_thenBabyNameHaveSameValue() async throws {
        // 1. given
        let babyName = "BabyName"

        // 2. when
        storage.babyName = babyName

        // 3. then
        #expect(storage.babyName == babyName)
        #expect(manager.babyName == babyName)
    }

    @Test mutating func whenBabyNameIsSetWithOneCharacter_thenBabyNameNotSave() async throws {
        // 1. given
        let babyName = "B"
        #expect(storage.babyName.isEmpty)
        #expect(manager.isBabyNameValide == nil)

        // 2. when
        manager.babyName = babyName

        // 3. then
        #expect(storage.babyName.isEmpty)
        #expect(manager.babyName.isEmpty)
        #expect(manager.isBabyNameValide == false)
    }

    @Test mutating func whenBabyNameIsSetWithNoCharacter_thenBabyNameNotSave() async throws {
        // 1. given
        let babyName = ""
        #expect(storage.babyName.isEmpty)
        #expect(manager.isBabyNameValide == nil)

        // 2. when
        manager.babyName = babyName

        // 3. then
        #expect(storage.babyName.isEmpty)
        #expect(manager.babyName.isEmpty)
        #expect(manager.isBabyNameValide == false)
    }

    // MARK: - Tests ParentName manager
    @Test func whenParentNameIsSet_thenParentNameIsSaved() async throws {
        // 1. given
        let parentName = "parentName"

        // 2. when
        manager.parentName = parentName

        // 3. then
        #expect(storage.parentName == parentName)
        #expect(manager.parentName == parentName)
    }

    @Test mutating func parentNameHaveValueInStorage_WhenParentNameIsGet_thenParentNameHaveSameValue() async throws {
        // 1. given
        let parentName = "parentName"

        // 2. when
        storage.parentName = parentName

        // 3. then
        #expect(storage.parentName == parentName)
        #expect(manager.parentName == parentName)
    }

    @Test mutating func whenParentNameIsSetWithOneCharacter_thenParentNameNotSave() async throws {
        // 1. given
        let parentName = "B"
        #expect(storage.parentName.isEmpty)
        #expect(manager.isParentNameValide == nil)

        // 2. when
        manager.parentName = parentName

        // 3. then
        #expect(storage.parentName.isEmpty)
        #expect(manager.parentName.isEmpty)
        #expect(manager.isParentNameValide == false)
    }

    @Test mutating func whenParentNameIsSetWithNoCharacter_thenParentNameNotSave() async throws {
        // 1. given
        let parentName = ""
        #expect(storage.parentName.isEmpty)
        #expect(manager.isParentNameValide == nil)

        // 2. when
        manager.parentName = parentName

        // 3. then
        #expect(storage.parentName.isEmpty)
        #expect(manager.parentName.isEmpty)
        #expect(manager.isParentNameValide == false)
    }
}
