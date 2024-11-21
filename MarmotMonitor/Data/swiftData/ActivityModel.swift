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
    @Relationship(deleteRule: .cascade) var activity: Activity
    var date: Date
    var activityCategory: String

    init(activity: Activity, date: Date) {
        self.id = UUID()
        self.activity = activity
        self.date = date
        self.activityCategory = activity.type.category
    }
}

@Model
class Activity {
    @Attribute(.unique) var id: UUID
    var type: ActivityType

    init(type: ActivityType) {
        self.id = UUID()
        self.type = type
    }

    var title: String {
        switch type {
           case .diaper: return "Couche"
           case .bottle: return "Biberon"
           case .breast: return "Allaitement"
           case .sleep: return "Sommeil"
           case .growth: return "Croissance"
           case .solid: return "Repas"
           }
       }

    var imageName: String {
        switch type {
        case .diaper: return "couche"
        case .bottle, .breast: return "biberon"
        case .sleep: return "sommeil"
        case .growth: return "croissance"
        case .solid: return "Repas"
        }
    }

    var color: Color {
        switch type {
        case .diaper: return .diaper
        case .bottle: return .feed
        case .breast: return .feed
        case .sleep: return .sleep
        default: return .growth
        }
    }
}

// MARK: - ENUM

enum MeasurementSystem: String, Codable {
    case metric = "Métrique"
    case imperial = "Impérial"
}

enum ActivityType: Codable, Equatable {
    case diaper(state: DiaperState)
    case bottle(volume: Double, measurementSystem: MeasurementSystem = .metric)
    case breast(duration: BreastDuration, lastBreast: BreastType)
    case sleep(duration: TimeInterval)
    case growth(data: GrowthData)
    case solid(composition: SolidQuantity)

    var category: String {
        switch self {
        case .sleep:
            return ActivityCategory.sleep.rawValue
        case .diaper:
            return ActivityCategory.diaper.rawValue
        case .bottle, .breast, .solid:
            return ActivityCategory.food.rawValue
        case .growth:
            return ActivityCategory.growth.rawValue
        }
    }
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

struct SolidQuantity: Codable, Equatable {
    let vegetable: Int
    let meat: Int
    let fruit: Int
    let dairyProduct: Int
    let cereal: Int
    let other: Int
}

struct GrowthData: Codable, Equatable {
    let weight: Double?
    let height: Double?
    let headCircumference: Double?
    var measurementSystem: MeasurementSystem = .metric
}

enum ActivityCategory: String {
    case sleep
    case diaper
    case food
    case growth
}