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

    init() {
        manager = OnBoardingManager()
    }

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
        // 1. given
        let initValue = manager.activeScreen

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
        // 1. given
        let initValue = manager.activeScreen

        // 2. when
        for _ in 0...10 {
            manager.previous()
        }

        // 3. then
        #expect(manager.activeScreen == OnBoardingManager.Screen.allCases.first!.rawValue)
    }
}
