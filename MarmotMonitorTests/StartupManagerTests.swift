//
//  StartupManagerTests.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import Testing
import SwiftUI
@testable import MarmotMonitor

struct StartupManagerTests {

    let manager: StartupManager
    let storage: AppStorageManagerProtocol

    init() {
        storage = MockAppStorageManager()
        manager = StartupManager(storageManager: storage)
    }

    @Test func whenOnBoardingFinishedFonctionIsCall_thenIsOnBoardingFinishedIsTrue() async throws {
        // 1. given
        #expect(storage.isOnBoardingFinished == false)

        // 2. when
        manager.onBoardingFinished()

        // 3. then
        #expect(storage.isOnBoardingFinished == true)
    }
}
