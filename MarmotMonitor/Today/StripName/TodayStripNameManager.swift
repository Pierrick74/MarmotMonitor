//
//  TodayStripNameManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/11/2024.
//

import SwiftUI

final class TodayStripNameManager: ObservableObject {
    private var storageManager: AppStorageManagerProtocol

    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
    }

    var welcomeMessage: String {
        return "Bonjour " + storageManager.parentName
    }

    var babyInfo: String {
        return storageManager.babyName + " à " + babyAge
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
