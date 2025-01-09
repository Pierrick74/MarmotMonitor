//
//  BreastAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2024.
//

import SwiftUI

/// ViewModel for BreastAddView
/// - Parameters:
/// - dataManager: Data manager to use for saving breast data
/// - Published:
/// - date: Date of the breast activity
/// - isSaveError: Bool to indicate if there was an error while saving the breast activity
/// - alertMessage: Message to show in case of error
/// - timerLeft: TimerObject for left breast
/// - timerRight: TimerObject for right breast
/// - range: ClosedRange<Date>: Range of date for breast activity
/// - functions:
/// - checkFirstBreast: Check which breast was used first
/// - saveBreast: Save breast activity to data manager
///
///
///
@MainActor
final class BreastAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var date: Date?
    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"

    @Published var timerLeft = TimerObject()
    @Published var timerRight = TimerObject()

    @Published var firstBreast: BreastType = .left

    // MARK: - Init
    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        // set timer action when start
        self.timerLeft.onTimerStateStart = { [weak self] in
            self?.timerRight.stopTimer()
            self?.checkFirstBreast(at: .left)
        }
        self.timerRight.onTimerStateStart = { [weak self] in
            self?.timerLeft.stopTimer()
            self?.checkFirstBreast(at: .right)
        }
    }

    // MARK: - Computed properties
    var totalTime: String {
        let totalSeconds = timerLeft.timeElapsed + timerRight.timeElapsed
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    var totalTimeAccessibilityLabel: String {
        let totalSeconds = timerLeft.timeElapsed + timerRight.timeElapsed
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return "Temps total" + String(format: "%02d minute :%02d seconde", minutes, seconds)
    }

    var accessibilityHintForDate: String {
        date != nil ?
        "Heure actuelle : \(date!.formatted(date: .abbreviated, time: .shortened))"
        : "Valeur Non définie"
    }

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    // MARK: - Functions
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
