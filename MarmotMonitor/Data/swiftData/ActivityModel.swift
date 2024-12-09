//
//  ActivityType.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI
import SwiftData

/// Model for baby activities
/// - Tag: ActivityType
/// - Note: This model is used to store all the activities of the baby.
/// - Note: Unit available for the measurement of the activities.
/// - Note: volum of bottle : ml or fluid ounce (floz)
/// - Note: height or head Conference  : cm or inch(in)
/// - Note: weight : kg or livres (lbs)

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

enum MeasurementSystem: String, Codable {
    case metric = "Métrique"
    case imperial = "Impérial"
}

enum DiaperState: String, Codable, Equatable {
    case wet = "Urine"
    case dirty = "Souillée"
    case both = "Mixte"
}

struct BreastDuration: Codable, Equatable {
    let leftDuration: TimeInterval
    let rightDuration: TimeInterval
}

enum BreastType: Codable, Equatable {
    case left
    case right
}

struct GrowthData: Codable, Equatable {
    let weight: Double?
    let height: Double?
    let headCircumference: Double?
    var measurementSystem: MeasurementSystem = .metric
}

enum ActivityCategory: String, Codable {
    case sleep = "Sommeil"
    case diaper = "Couche"
    case food = "Repas"
    case growth = "Croissance"

    var color: Color {
        Color(self.rawValue)
    }
}
