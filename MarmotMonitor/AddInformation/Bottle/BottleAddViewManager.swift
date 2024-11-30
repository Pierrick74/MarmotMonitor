//
//  BottleAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/11/2024.
//

import SwiftUI

@MainActor
final class BottleAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared
    private var storageManager: AppStorageManagerProtocol

    @Published var percent: Double = 20.0 {
        didSet {
            self.volume = "\(Int(percent * 3.6))" + (storageManager.isMetricUnit ? " ml" : " oz")
            self.heightIndicator = percent * 3
        }
    }

    @Published var heightIndicator: Double
    @Published var volume: String
    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"
    @Published var date: Date?

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    // MARK: - Initialization
    init(dataManager: SwiftDataManagerProtocol? = nil, storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        self.storageManager = storageManager
        volume = "72" + (storageManager.isMetricUnit ? " ml" : " oz")
        heightIndicator = 60
    }

    // MARK: - Functions
    func setPercent(_ amount: Double) {
        self.percent = amount
    }

    func saveBottle() {
        isSaveError = false

        guard percent > 0 else {
            isSaveError = true
            alertMessage = "Veuillez sélectionner un volume"
            return
        }

        let activityDate = date ?? .now
        let volume = percent * 3.6
        let unit: MeasurementSystem = storageManager.isMetricUnit ? .metric : .imperial
        let bottle = BabyActivity(activity: .bottle(volume: volume, measurementSystem: unit), date: activityDate)

        do {
            try dataManager.addActivity(bottle)
        } catch let error as LocalizedError {
            isSaveError = true
            alertMessage = "\(error.errorDescription ?? "Une erreur inconnue s'est produite.")"
        } catch {
            isSaveError = true
            alertMessage = "Une erreur inattendue s'est produite : \(error)"
        }
    }
}
