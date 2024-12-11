//
//  GrowthViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 11/12/2024.
//

import Foundation

/// Manages the growth data view and its interactions
///
/// This class handles:
/// - Fetching and filtering growth-related activities
/// - Managing selected measurement type
/// - Converting and displaying data based on user preferences
///
/// - Note: Uses dependency injection for data and storage managers
@MainActor
final class GrowthViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared
    private var storageManager: AppStorageManagerProtocol

    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
        setupData()
    }

    @Published var dataShow = [Int: Double]()
    @Published var selectedPosition = 0 {
        didSet {
            setupData()
        }
    }

    var title: String {
        switch selectedPosition {
        case 0:
            return "Poids"
        case 1:
            return "Taille"
        case 2:
            return "Perimètre crânien"
        default:
            return "Poids"
        }
    }

    var unit: String {
        switch selectedPosition {
        case 0:
            return storageManager.isMetricUnit ? "en Kg" : "en Lbs"
        case 1:
            return storageManager.isMetricUnit ? "en Cm" : "en In"
        case 2:
            return storageManager.isMetricUnit ? "en Cm" : "en In"
        default:
            return storageManager.isMetricUnit ? "en Kg" : "en Lbs"
        }
    }

    func setupData() {
        let data = dataManager.fetchFilteredActivities(with: [.growth])
        dataShow = [:]

        for activity in data {
            guard case .growth(let data) = activity.activity else { continue }
            let date = activity.date
            var value: Double

            switch selectedPosition {
            case 0:
                guard let weight = data.weight else { continue }
                value = checkWeightUnit(weight, type: data.measurementSystem)
            case 1:
                guard let height = data.height else { continue }
                value = checkMesureUnit(height, type: data.measurementSystem)
            case 2:
                guard let headCircumference = data.headCircumference else { continue }
                value = checkMesureUnit(headCircumference, type: data.measurementSystem)
            default:
                guard let weight = data.weight else { continue }
                value = checkWeightUnit(weight, type: data.measurementSystem)
            }

            let monthDifference = Calendar.current.dateComponents([.month], from: storageManager.babyBirthday, to: date).month
            guard let month = monthDifference else { continue }
            dataShow[month] = value
        }
    }

    private func checkMesureUnit(_ value: Double, type: MeasurementSystem) -> Double {
        let userUnit = storageManager.isMetricUnit ? MeasurementSystem.metric : MeasurementSystem.imperial
        guard type != userUnit else { return value }

        switch type {
        case .metric:
            return value * 2.20462
        case .imperial:
            return value / 2.20462
        }
    }

    private func checkWeightUnit(_ value: Double, type: MeasurementSystem) -> Double {
        let userUnit = storageManager.isMetricUnit ? MeasurementSystem.metric : MeasurementSystem.imperial
        guard type != userUnit else { return value }

        switch type {
        case .metric:
            return value * 2.20462
        case .imperial:
            return value / 2.20462
        }
    }
}
