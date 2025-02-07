//
//  TodayStripNameManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/11/2024.
//

import SwiftUI
/// Manager that provides the information to display in the today strip
final class TodayStripNameManager: ObservableObject {
    // MARK: - Dependencies
    private var storageManager: AppStorageManagerProtocol

    // MARK: - Initializer
    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
    }

    // MARK: - Computed properties
    var welcomeMessage: String {
        return "Bonjour " + storageManager.parentName
    }

    var babyInfo: String {
        return storageManager.babyName + " a " + babyAge
    }

    var babyAge: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: storageManager.babyBirthday, to: .now)

        let years = components.year ?? 0
        let months = components.month ?? 0
        let day = components.day ?? 0

        let yearsText = years > 1 ? "ans" : "an"
        let dayText = day > 1 ? "jours" : "jour"

        if years > 0 {
            return "\(years) \(yearsText) et \(months) mois"
        } else if months > 0 {
            return "\(months) mois et \(day) \(dayText)"
        } else {
            return "\(day) \(dayText)"
        }
    }
}
