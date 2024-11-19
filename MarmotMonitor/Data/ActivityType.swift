//
//  ActivityType.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI

enum ActivityType {
    case diaper(state: DiaperState)
    case bottle(quantity: Int)
    case breast(duration: BreastDuration)
    case sleep(duration: Int)
    case growth(data: GrowthData)
    case solid(composition: SolidQuantity)

    static var allTitle: [String] {
        return ["Couche", "Biberon", "Allaitement", "Sommeil", "Croissance", "Repas"]
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

    var color: Color {
        switch self {
        case .diaper: return .diaper
        case .bottle: return .feed
        case .breast: return .feed
        case .sleep: return .sleep
        default: return .growth
        }
    }

    enum DiaperState: String, CaseIterable {
        case wet = "Urine"
        case dirty = "Souillée"
        case both = "Mixte"
    }

    struct BreastDuration {
        let leftDuration: Int
        let rightDuration: Int
    }

    struct SolidQuantity {
        let vegetable: Int
        let meat: Int
        let fruit: Int
        let dairyProduct: Int
        let cereal: Int
        let other: Int
    }

    struct GrowthData {
        let weight: Double
        let height: Double
        let headCircumference: Double
    }

    enum GrowthField {
        case height
        case weight
        case head

        var unit: String {
            switch self {
            case .height, .head: return "cm"
            case .weight: return "g"
            }
        }

        var title: String {
            switch self {
            case .height: return "Taille"
            case .weight: return "Poids"
            case .head: return "Tête"
            }
        }
    }
}
