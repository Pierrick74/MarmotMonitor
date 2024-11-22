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
}

// MARK: - ENUM
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

    var title: String {
        switch self {
           case .diaper: return "Couche"
           case .bottle: return "Biberon"
           case .breast: return "Allaitement"
           case .sleep: return "Sommeil"
           case .growth: return "Croissance"
           case .solid: return "Repas"
           }
       }

    var imageName: String {
        switch self {
        case .diaper: return "couche"
        case .bottle, .breast: return "biberon"
        case .sleep: return "sommeil"
        case .growth: return "croissance"
        case .solid: return "Repas"
        }
    }

    var color: String {
        switch self {
        case .diaper: return "Diaper"
        case .bottle: return "Feed"
        case .breast: return "Feed"
        case .sleep: return "Sleep"
        default: return "Growth"
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

enum ActivityCategory: String, Codable {
    case sleep
    case diaper
    case food
    case growth
}
