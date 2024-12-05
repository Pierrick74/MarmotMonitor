//
//  TimerManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 04/12/2024.
//

import Testing
import SwiftUI
import SwiftData
@testable import MarmotMonitor

struct TimerObjectTests {
    @Test func testTimer_WhenInitialized_ThenInitialStateIsCorrect() {
        // 1. given
        let timer = TimerObject()

        // 2. when

        // 3. then
        #expect(timer.timeElapsed == 0)
        #expect(timer.isRunning == false)
    }

    @Test func testTimer_WhenStarted_ThenTimerRuns() async {
        // 1. given
        let timer = TimerObject()

        // 2. when
        timer.startTimer()

        // 3. then
        #expect(timer.isRunning == true)
    }

    @Test func testTimer_WhenStopped_ThenTimerStops() async {
        let timer = TimerObject()

        timer.startTimer()

        try? await Task.sleep(for: .seconds(2))

        let timeBeforeStopping = timer.timeElapsed
        timer.stopTimer()

        try? await Task.sleep(for: .seconds(2))

        #expect(timer.timeElapsed == timeBeforeStopping)
        #expect(timer.isRunning == false)
    }

    @Test func testTimer_WhenReset_ThenTimerResetsToZero() async {
        let timer = TimerObject()

        timer.startTimer()

        try? await Task.sleep(for: .seconds(2))

        timer.resetTimer()

        #expect(timer.timeElapsed == 0)
        #expect(timer.isRunning == false)
    }

    @Test func testTimer_DisplayTime_FormatsCorrectly() {
        let timer = TimerObject()

        timer.timeElapsed = 125 // 2 minutes et 5 secondes
        #expect(timer.displayTime() == "02:05")

        timer.timeElapsed = 3661 // 1 heure, 1 minute et 1 seconde
        #expect(timer.displayTime() == "01:01")
    }
}
