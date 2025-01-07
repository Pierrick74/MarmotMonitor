//
//  TimerManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

/// A class responsible for managing a timer with observable state.
/// - Parameters:
///   - onTimerStateStart: A closure to be executed when the timer starts.
///   - Returns: An instance of `TimerObject`.

@Observable
final class TimerObject {
    private var timer: Timer?
    var isRunning = false
    var timeElapsed = 0
    var onTimerStateStart: (() -> Void)?

    init(onTimerStateStart: (() -> Void)? = nil) {
        self.onTimerStateStart = onTimerStateStart
    }

    func startTimer() {
        if timer == nil {
            onTimerStateStart?()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.timeElapsed += 1
            }
            isRunning = true
        }
    }

    func stopTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            isRunning = false
        }
    }

    func resetTimer() {
        stopTimer()
        timeElapsed = 0
    }

    /// Converts the elapsed time to a formatted string (MM:SS).
    /// - Returns: A string representing the elapsed time in minutes and seconds.
    func displayTime() -> String {
        let seconds = timeElapsed % 60
        let minutes = (timeElapsed / 60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Converts the elapsed time to a formatted string (MM:SS).
    /// - Returns: A string representing the elapsed time in minutes and seconds for label accessibility.
    func displayTimeAccessibility() -> String {
        let seconds = timeElapsed % 60
        let minutes = (timeElapsed / 60) % 60
        let timerRunning = isRunning ? "Timer en route " : "Timer arrêté "

        return timerRunning + String(format: "%d minute and %d second", minutes, seconds)
    }
}
