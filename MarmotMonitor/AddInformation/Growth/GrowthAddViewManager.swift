//
//  GrowthAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI
/// A manager for handling the growth data logic in `GrowthAddView`.
/// - This class is responsible for managing input values, converting units, and saving the growth activity.
/// - Conforms to `ObservableObject` to update the UI when properties change.
@MainActor
final class GrowthAddViewManager: ObservableObject {
    // MARK: - Dependancies
    private var dataManager: SwiftDataManagerProtocol
    private var storageManager: AppStorageManagerProtocol

    // MARK: - Initialization
    init(
        dataManager: SwiftDataManagerProtocol? = nil,
        storageManager: AppStorageManagerProtocol = AppStorageManager.shared
    ) {
        self.dataManager = dataManager ?? SwiftDataManager.shared
        self.storageManager = storageManager
    }

    // MARK: - Properties
    // data range for date picker
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

    // MARK: - Functions
    func saveGrowth() {
        isSaveError = false

        guard isInformationToSave else {
            isSaveError = true
            alertMessage = "Veuillez sélectionner une information"
            return
        }

        let activityDate = date ?? .now

        let unit: MeasurementSystem = storageManager.isMetricUnit ? .metric : .imperial
        let growth = BabyActivity(
            activity:
                    .growth(
                        data: GrowthData(
                            weight: weight,
                            height: height,
                            headCircumference: headSize,
                            measurementSystem: unit
                        )
                    ),
            date: activityDate
        )

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
