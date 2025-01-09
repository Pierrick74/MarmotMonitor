//
//  SleepAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI
/// A manager for handling the sleep data logic in `SleepAddView`.
/// - Manages the selection of start and end dates and ensures validation before saving.
/// - Conforms to `ObservableObject` to update the UI when properties change.
@MainActor
final class SleepAddViewManager: ObservableObject {
    // MARK: - Dependencies
    private var dataManager: SwiftDataManagerProtocol

    // MARK: - Init
    init(dataManager: SwiftDataManagerProtocol? = nil) {
        self.dataManager = dataManager ?? SwiftDataManager.shared
    }

    // MARK: - Published Properties
    @Published var isSaveError = false
    @Published var alertMessage = ""

    @Published var startDate: Date? {
        didSet { updateIsActiveButtonSave() }
    }
    @Published var endDate: Date? {
        didSet { updateIsActiveButtonSave() }
    }
    @Published var isActiveButtonSave: Bool = false

    // MARK: - Computed Properties
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
        }
        return Date.distantPast...Date.now
    }

    var endRange: ClosedRange<Date>? {
        guard let startDate = startDate else { return nil }
        let start = startDate.addingTimeInterval(60)
        return start...Date.distantFuture
    }

    // MARK: - Functions
    /// Saves the sleep data as a `BabyActivity` object.
    /// - Validates that both dates are selected and the interval is positive.
    /// - Updates `isSaveError` and `alertMessage` in case of failure.
    func saveSleep() {
        // validate date selection
        guard let endDate = endDate, let startDate = startDate else {
            isSaveError = true
            alertMessage = "Veuillez sélectionner une date de début et de fin"
            return
        }

        // validate time interval
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

    // MARK: - Private Functions
    private func updateIsActiveButtonSave() {
        isActiveButtonSave = startDate != nil && endDate != nil
    }
}
