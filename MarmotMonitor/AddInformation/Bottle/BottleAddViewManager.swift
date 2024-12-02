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
    private let maxVolume: Double = 360

    @Published var percent: Double = 20.0 {
        didSet {
            self.volume = Int(percent * (maxVolume / 100))
            self.heightIndicator = percent * 3
        }
    }

    @Published var heightIndicator: Double
    @Published var volume: Int {
        didSet {
            self.volumeInformation = "\(Int(volume))" + (storageManager.isMetricUnit ? " ml" : " oz")
        }
    }
    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"
    @Published var date: Date?
    @Published var volumeInformation: String

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    // MARK: - Initialization
    init(dataManager: SwiftDataManagerProtocol? = nil, storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        self.storageManager = storageManager
        volume = 70
        heightIndicator = 60
        volumeInformation = "\(70)" + (storageManager.isMetricUnit ? " ml" : " oz")
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

        let unit: MeasurementSystem = storageManager.isMetricUnit ? .metric : .imperial
        let bottle = BabyActivity(activity: .bottle(volume: Double(volume), measurementSystem: unit), date: activityDate)

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

    func incrementVolume() {
        volume = min(volume + 10, Int(maxVolume))
    }

    func decrementVolume() {
        volume = max(volume - 10, 0)
    }
}
