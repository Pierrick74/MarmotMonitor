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

    init() {
        manager = StartupManager()
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.isOnBoardingFinished)
    }

    @Test func whenOnBoardingFinishedFonctionIsCall_thenIsOnBoardingFinishedIsTrue() async throws {
        // 1. given
        let isOnBoardingFinishedFirstStatus = manager.isOnBoardingFinished

          // 2. when
        manager.onBoardingFinished()

          // 3. then
        #expect(isOnBoardingFinishedFirstStatus == false)
        #expect(manager.isOnBoardingFinished == true)
    }
}
