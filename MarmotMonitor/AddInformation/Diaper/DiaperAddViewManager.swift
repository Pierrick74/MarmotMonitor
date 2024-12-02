//
//  DiaperAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 27/11/2024.
//

import SwiftUI

@MainActor
final class DiaperAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var date: Date?
    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"
    @Published var isWet = false
    @Published var isDirty = false

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    var diaperColor: [Color] {
        if isWet && isDirty {
            return [Color.yellow, Color(uiColor: .diaperButton), Color(.lightGray)]
        } else if isWet {
            return [Color.yellow, Color(.lightGray)]
        } else if isDirty {
            return [Color(uiColor: .diaperButton), Color(.lightGray)]
        } else {
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

    private func getDiaperState() -> DiaperState? {
        guard !(isWet == false && isDirty == false) else {return nil}

        if isWet == true && isDirty == false {
            return .wet
        } else if isDirty == true && isWet == false {
            return .dirty
        } else {
            return .both
        }
    }
}
