//
//  BreastAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2024.
//

import SwiftUI

@MainActor
final class BreastAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var date: Date?
    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"

    @Published var timerLeft = TimerObject()
    @Published var timerRight = TimerObject()

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        self.timerLeft.onTimerStateStart = { [weak self] in
            self?.timerRight.stopTimer()
            self?.checkFirstBreast(at: .left)
        }
        self.timerRight.onTimerStateStart = { [weak self] in
            self?.timerLeft.stopTimer()
            self?.checkFirstBreast(at: .right)
        }
    }

    var totalTime: String {
        let totalSeconds = timerLeft.timeElapsed + timerRight.timeElapsed
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    @Published var firstBreast: BreastType = .left

    func checkFirstBreast(at brestType: BreastType) {
        switch brestType {
        case .left:
            if timerRight.timeElapsed == 0 {
                firstBreast = .left
            }
        case .right:
            if timerLeft.timeElapsed == 0 {
                firstBreast = .right
            }
        }
    }

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    func saveBreast() {
        isSaveError = false

        let breastDate = date ?? .now

        let breastDuration = BreastDuration(
            leftDuration: Double(timerLeft.timeElapsed),
            rightDuration: Double(timerRight.timeElapsed)
        )

        let lastBreast = getLastBreast()

        let babyActivity = BabyActivity(
            activity: .breast(duration: breastDuration, lastBreast: lastBreast),
            date: breastDate)

        do {
            try dataManager.addActivity(babyActivity)
        } catch let error as LocalizedError {
            isSaveError = true
            alertMessage = "\(error.errorDescription ?? "Une erreur inconnue s'est produite.")"
        } catch {
            isSaveError = true
            alertMessage = "Une erreur inattendue s'est produite : \(error)"
        }
    }

    private func getLastBreast() -> BreastType {
        switch firstBreast {
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}
