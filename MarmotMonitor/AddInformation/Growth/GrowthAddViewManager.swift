//
//  GrowthAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI

@MainActor
final class GrowthAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared
    private var storageManager: AppStorageManagerProtocol

    init(dataManager: SwiftDataManagerProtocol? = nil, storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        self.storageManager = storageManager
    }

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    var sizeUnit: String {
        storageManager.isMetricUnit ? "cm" : "in"
    }

    var weightUnit: String {
        storageManager.isMetricUnit ? "kg" : "lbs"
    }

    @Published var date: Date?

    @Published var height: Double?
    var heightDescription: String? {
        (height != nil) ? "\(height!)" + " " + sizeUnit : nil
    }

    @Published var weight: Double?
    var weightDescription: String? {
        (weight != nil) ? "\(weight!)" + " " + weightUnit : nil
    }

    @Published var headSize: Double?
    var headSizeDescription: String? {
        (headSize != nil) ? "\(headSize!)" + " " + sizeUnit : nil
    }

    @Published var isSaveError = false
    @Published var alertMessage = "Erreur inconnue"

    var isInformationToSave: Bool {
        height != nil || weight != nil || headSize != nil
    }

    func saveGrowth() {
        isSaveError = false

        guard isInformationToSave else {
            isSaveError = true
            alertMessage = "Veuillez sélectionner une information"
            return
        }

        let activityDate = date ?? .now

        let unit: MeasurementSystem = storageManager.isMetricUnit ? .metric : .imperial
        let growth = BabyActivity(activity:
                .growth(data: GrowthData(
                                weight: weight,
                                height: height,
                                headCircumference: headSize,
                                measurementSystem: unit)
                       ),
                            date: activityDate)

        do {
            try dataManager.addActivity(growth)
        } catch let error as LocalizedError {
            isSaveError = true
            alertMessage = "\(error.errorDescription ?? "Une erreur inconnue s'est produite.")"
        } catch {
            isSaveError = true
            alertMessage = "Une erreur inattendue s'est produite : \(error)"
        }
    }
}
