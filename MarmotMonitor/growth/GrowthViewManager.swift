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
    // MARK: - Dependencies
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared
    private var storageManager: AppStorageManagerProtocol

    // MARK: - intialization
    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
        setupData()
    }

    // MARK: - Published Properties
    @Published var dataShow: [(key: Int, value: Double)] = []

    @Published var selectedPosition = 0 {
        didSet {
            setupData()
        }
    }
    @Published var listData: [BabyActivity] = []

    // MARK: - Computed Properties
    var title: String {
        switch selectedPosition {
        case 0: return "Taille"
        case 1: return "Poids"
        case 2: return "Périmètre crânien"
        default: return "Poids"
        }
    }

    var unit: String {
        let metricUnit: String
        let imperialUnit: String

        switch selectedPosition {
        case 0, 2:
            metricUnit = "en Cm"
            imperialUnit = "en In"
        case 1:
            metricUnit = "en Kg"
            imperialUnit = "en Lbs"
        default:
            metricUnit = "en Kg"
            imperialUnit = "en Lbs"
        }
        return storageManager.isMetricUnit ? metricUnit : imperialUnit
    }

    // MARK: - functions
    func refreshData() {
        setupData()
        fetchGrowthActivities()
    }

    func deleteActivity(_ activity: BabyActivity) {
        dataManager.deleteActivity(activity: activity)
        fetchGrowthActivities()
    }

    // MARK: - Private functions
    /// Prepares the growth data for display in charts.
        private func setupData() {
            let activities = dataManager.fetchFilteredActivities(with: [.growth])
            var values: [Int: Double] = [:]

            for activity in activities {
                guard let (month, value) = extractMeasurement(from: activity) else { continue }
                values[month] = max(values[month] ?? 0, value)
            }

            dataShow = values.sorted(by: { $0.key < $1.key })
        }

        /// Extracts the relevant measurement for the selected position.
        /// - Parameter activity: The `BabyActivity` to process.
        /// - Returns: A tuple containing the month and the measurement value, or `nil` if invalid.
        private func extractMeasurement(from activity: BabyActivity) -> (Int, Double)? {
            guard case .growth(let data) = activity.activity else { return nil }
            let date = activity.date
            let value: Double?

            switch selectedPosition {
            case 0: value = data.height.map { checkMeasurementUnit($0, type: data.measurementSystem) }
            case 1: value = data.weight.map { checkWeightUnit($0, type: data.measurementSystem) }
            case 2: value = data.headCircumference.map { checkMeasurementUnit($0, type: data.measurementSystem) }
            default: return nil
            }

            guard let unwrappedValue = value,
                  let month = Calendar.current.dateComponents([.month], from: storageManager.babyBirthday, to: date).month else {
                return nil
            }

            return (month, unwrappedValue)
        }

    /// Converts a measurement to the user's preferred unit system.
    private func checkMeasurementUnit(_ value: Double, type: MeasurementSystem) -> Double {
        let userUnit = storageManager.isMetricUnit ? MeasurementSystem.metric : MeasurementSystem.imperial
        guard type != userUnit else { return value }

        return type == .metric ? value * 0.393701 : value / 0.393701 // cm to inches conversion
    }

    /// Converts weight to the user's preferred unit system.
    private func checkWeightUnit(_ value: Double, type: MeasurementSystem) -> Double {
        let userUnit = storageManager.isMetricUnit ? MeasurementSystem.metric : MeasurementSystem.imperial
        guard type != userUnit else { return value }

        return type == .metric ? value * 2.20462 : value / 2.20462 // kg to lbs conversion
    }

    /// Fetches growth activities for list display.
    private func fetchGrowthActivities() {
        listData = dataManager.fetchFilteredActivities(with: [.growth])
    }
}
