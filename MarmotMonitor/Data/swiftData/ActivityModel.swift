//
//  ActivityType.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI
import SwiftData

// MARK: - BabyActivity

/// A model representing a baby's activity.
///
/// This class stores details about various activities such as sleep, diaper changes, feeding, and growth metrics.
/// - Parameters:
///   - id: A unique identifier for the activity.
///   - activity: The specific type of activity.
///   - date: The date and time the activity occurred.
///   - activityCategory: The category of the activity (e.g., "Sommeil").
///   - activityTitre: The title of the activity (e.g., "Couche").
///   - activityColor: The color associated with the activity.
///   - activityImageName: The name of the image representing the activity.
@Model
class BabyActivity {
    @Attribute(.unique) var id: UUID
    var activity: ActivityType
    var date: Date
    var activityCategory: String
    var activityTitre: String
    var activityColor: String
    var activityImageName: String

    init(activity: ActivityType, date: Date) {
        self.id = UUID()
        self.activity = activity
        self.date = date
        self.activityCategory = activity.category
        self.activityTitre = activity.title
        self.activityColor = activity.color
        self.activityImageName = activity.imageName
    }

    /// Retrieves the `ActivityCategory` from the string representation.
    /// - Returns: The associated `ActivityCategory`, or `.food` as the default.
    func getCategory() -> ActivityCategory {
        switch activityCategory {
        case "Sommeil":
            return ActivityCategory.sleep
        case "Couche":
            return ActivityCategory.diaper
        case "Repas":
            return ActivityCategory.food
        case "Croissance":
            return ActivityCategory.growth
        default:
            return ActivityCategory.food
        }
    }
}

// MARK: - ENUM
/// An enum representing various activity types.
enum ActivityType: Codable, Equatable {
    case diaper(state: DiaperState)
    case bottle(volume: Double, measurementSystem: MeasurementSystem = .metric)
    case breast(duration: BreastDuration, lastBreast: BreastType)
    case sleep(duration: TimeInterval)
    case growth(data: GrowthData)

    var category: String {
        switch self {
        case .sleep:
            return ActivityCategory.sleep.rawValue
        case .diaper:
            return ActivityCategory.diaper.rawValue
        case .bottle, .breast:
            return ActivityCategory.food.rawValue
        case .growth:
            return ActivityCategory.growth.rawValue
        }
    }

    var title: String {
        switch self {
           case .diaper: return "Couche"
           case .bottle: return "Biberon"
           case .breast: return "Allaitement"
           case .sleep: return "Sommeil"
           case .growth: return "Croissance"
           }
       }

    var imageName: String {
        switch self {
        case .diaper: return ActivityCategory.diaper.rawValue
        case .bottle, .breast: return ActivityCategory.food.rawValue
        case .sleep: return ActivityCategory.sleep.rawValue
        case .growth: return ActivityCategory.growth.rawValue
        }
    }

    var color: String {
        switch self {
        case .diaper: return ActivityCategory.diaper.rawValue
        case .bottle: return ActivityCategory.food.rawValue
        case .breast: return ActivityCategory.food.rawValue
        case .sleep: return ActivityCategory.sleep.rawValue
        case .growth: return ActivityCategory.growth.rawValue
        }
    }
}

// MARK: - Supporting Types

/// Measurement system for units.
enum MeasurementSystem: String, Codable {
    case metric = "Métrique"
    case imperial = "Impérial"
}

/// state of a diaper during changes
enum DiaperState: String, Codable, Equatable {
    case wet = "Urine"
    case dirty = "Souillée"
    case both = "Mixte"
}

/// A struct representing the duration of breastfeeding.
struct BreastDuration: Codable, Equatable {
    let leftDuration: TimeInterval
    let rightDuration: TimeInterval
}

/// Types of breasts for breastfeeding tracking.
enum BreastType: Codable, Equatable {
    case left
    case right
}

/// Data related to a baby's growth metrics.
struct GrowthData: Codable, Equatable {
    let weight: Double?
    let height: Double?
    let headCircumference: Double?
    var measurementSystem: MeasurementSystem = .metric
}

/// Categories of activities.
enum ActivityCategory: String, Codable {
    case sleep = "Sommeil"
    case diaper = "Couche"
    case food = "Repas"
    case growth = "Croissance"

    var color: Color {
        Color(self.rawValue)
    }

    var colorBarre: Color {
        Color(self.rawValue+"Barre")
    }
}
