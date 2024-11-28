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

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    @Published var isSaveError = false
    @Published var alertMessage = ""

    @Published var startDate: Date? {
        didSet { updateIsActiveButtonSave() }
    }
    @Published var endDate: Date? {
        didSet { updateIsActiveButtonSave() }
    }
    @Published var isActiveButtonSave: Bool = false

    private func updateIsActiveButtonSave() {
        isActiveButtonSave = startDate != nil && endDate != nil
    }

    var accessibilityHintForStartDate: String {
        startDate != nil ?
        "Heure actuelle : \(startDate!.formatted(date: .abbreviated, time: .shortened))"
        : "Valeur Non définie"
    }

    var accessibilityHintForEndDate: String {
        endDate != nil ?
        "Heure actuelle : \(endDate!.formatted(date: .abbreviated, time: .shortened))"
        : "Valeur Non définie"
    }

    var startRange: ClosedRange<Date> {
        if let end = endDate {
            return Date.distantPast...end.addingTimeInterval(-60)
        } else {
            return Date.distantPast...Date.now
        }
    }

    var endRange: ClosedRange<Date>? {
        guard let startDate = startDate else { return nil }
        let start = startDate.addingTimeInterval(60)
        return start...Date.distantFuture
    }

    func saveSleep() {
        guard let endDate = endDate, let startDate = startDate else {
            isSaveError = true
            alertMessage = "Veuillez sélectionner une date de début et de fin"
            return
        }

        let timeInterval = endDate.timeIntervalSince(startDate)

        guard timeInterval > 0 else {
            isSaveError = true
            alertMessage = "Merci de verifier les dates"
            return
        }

        let babyActivity = BabyActivity(
            activity: .sleep(duration: timeInterval),
            date: startDate)
        do {
            try dataManager.addActivity(babyActivity)
        } catch {
            isSaveError = true
            alertMessage = "Activité Sommeil déja présente dans cette plage horraire"
        }
    }
}
