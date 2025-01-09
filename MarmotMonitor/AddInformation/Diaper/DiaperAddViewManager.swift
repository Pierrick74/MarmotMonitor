//
//  DiaperAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 27/11/2024.
//

import SwiftUI
/// A view model for managing the state and logic of the DiaperAddView.
/// - Responsible for tracking diaper status, managing save operations, and handling errors.
@MainActor
final class DiaperAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var date: Date?
    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"
    @Published var isWet = false
    @Published var isDirty = false

    /// Initializes the view model with an optional custom data manager.
    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    /// Determines the gradient colors for the diaper status visualization.
    /// - Wet: Yellow to light gray.
    /// - Dirty: Diaper button color to light gray.
    /// - Both: Yellow, diaper button color, and light gray.
    /// - Default: Light gray.
    var diaperColor: [Color] {
        switch (isWet, isDirty) {
        case (true, true):
            return [Color.yellow, Color(uiColor: .diaperButton), Color(.lightGray)]
        case (true, false):
            return [Color.yellow, Color(.lightGray)]
        case (false, true):
            return [Color(uiColor: .diaperButton), Color(.lightGray)]
        case (false, false):
            return [Color(.lightGray)]
        }
    }

    var accessibilityHintForDate: String {
        guard let date = date else { return "" }
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }

    func saveDiaper() {
        isSaveError = false
        guard let state = getDiaperState()
        else {
            isSaveError = true
            alertMessage = "Veuillez sélectionner un état de couche"
            return
        }
        let diaperDate = date ?? .now

        let babyActivity = BabyActivity(
            activity: .diaper(state: state),
            date: diaperDate)

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

    // MARK: - Private
    /// Determines the diaper state based on the `isWet` and `isDirty` properties.
    /// - Returns: A `DiaperState` value (`wet`, `dirty`, `both`, or `nil` if no state is selected).
    private func getDiaperState() -> DiaperState? {
        switch (isWet, isDirty) {
        case (false, false):
            return nil
        case (true, false):
            return .wet
        case (false, true):
            return .dirty
        case (true, true):
            return .both
        }
    }
}
