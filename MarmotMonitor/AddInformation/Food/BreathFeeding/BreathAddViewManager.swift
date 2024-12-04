//
//  BreathAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2024.
//

import SwiftUI

@MainActor
final class BreathAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var date: Date?
    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"

    @Published var timerG: TimerObject = TimerObject()
    @Published var timerD: TimerObject = TimerObject()

    var totalTime: String {
            let totalSeconds = timerG.timeElapsed + timerD.timeElapsed
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }
}
