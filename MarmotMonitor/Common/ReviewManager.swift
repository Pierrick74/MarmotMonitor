//
//  ReviewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/01/2025.
//

import SwiftUI
import StoreKit

class ReviewManager: ObservableObject {
    @Environment(\.requestReview) var requestReview

    var dataManager: AppStorageManagerProtocol
    static let shared = ReviewManager()

    init(dataManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.dataManager = dataManager
    }

    func checkForReview() -> Bool {
        if checkDateForRequest() == true {
            dataManager.lastDateForReview = Date.now
            return true
        }
        return false
    }

    private func checkDateForRequest() -> Bool {
        guard let lastDate = dataManager.lastDateForReview?.timeIntervalSince1970 else {
            return true
        }
        let currentDate = Date().timeIntervalSince1970
        let sixMonthsInSeconds: TimeInterval = 6 * 30 * 24 * 60 * 60

        if currentDate - lastDate >= sixMonthsInSeconds {
            return true
        }
        return false
    }
}
