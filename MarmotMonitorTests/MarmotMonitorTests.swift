//
//  MarmotMonitorTests.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 29/10/2024.
//

import Testing
import SwiftUI
@testable import MarmotMonitor

struct StartupManagerTests {
    @Test func whenOnBoardingFinishedFonctionIsCall_thenIsOnBoardingFinishedIsTrue() async throws {
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.isOnBoardingFinished)
        // 1. given
        let startupManager = StartupManager()
        let isOnBoardingFinishedFirstStatus = startupManager.isOnBoardingFinished

          // 2. when
        startupManager.onBoardingFinished()

          // 3. then
        #expect(isOnBoardingFinishedFirstStatus == false)
        #expect(startupManager.isOnBoardingFinished == true)
    }

}
