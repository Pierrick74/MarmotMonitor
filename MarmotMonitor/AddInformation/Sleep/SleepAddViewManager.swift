//
//  SleepAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI

@MainActor
final class SleepAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var startDate: Date?
    @Published var endDate: Date?

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    var accessibilityHintForStartDate: String {
        startDate != nil ?
        "Heure actuelle : \(startDate!.formatted(date: .abbreviated, time: .shortened))"
        : "Valeur Non définie"
    }

    var accessibilityHintForEndDate: String {
        endDate != nil ?
        "Heure actuelle : \(startDate!.formatted(date: .abbreviated, time: .shortened))"
        : "Valeur Non définie"
    }

    var startRange: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    var endRange: ClosedRange<Date>? {
        (startDate != nil) ? startDate!...Date.distantFuture : nil
    }

    func saveSleep() {
        guard let endDate = endDate, let startDate = startDate else { return }
        let timeInterval = endDate.timeIntervalSince(startDate)
        let babyActivity = BabyActivity(
            activity: .sleep(duration: timeInterval),
            date: startDate)
        dataManager.addActivity(activity: babyActivity)
    }
}
