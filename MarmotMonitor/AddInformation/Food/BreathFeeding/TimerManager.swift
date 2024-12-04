//
//  TimerManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

@Observable
class TimerObject {
    var timer: Timer?
    var isRunning = false
    var timeElapsed = 0

    func startTimer() {
        if timer == nil {
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

    func displayTime() -> String {
        let seconds = timeElapsed % 60
        let minutes = (timeElapsed / 60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
