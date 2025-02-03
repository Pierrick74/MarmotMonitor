//
//  AppIconTheme.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/12/2024.
//

import SwiftUI

/// Enum that represents the different app icon themes
enum AppIconTheme: String, CaseIterable {
    case blackDefault = "Noir"
    case pink = "Rose"
    case blue = "Bleu"
    case yellow = "Jaune"
    case green = "Vert"
    case violet = "Violet"

    var iconName: String? {
        switch self {
        case .blackDefault:
            return nil
        case .pink:
            return "AppIcon1"
        case .blue:
            return "AppIcon2"
        case .yellow:
            return "AppIcon3"
        case .green:
            return "AppIcon4"
        case .violet:
            return "AppIcon5"
        }
    }
    
    var iconImageName: String? {
        switch self {
        case .blackDefault:
            return "Icon"
        case .pink:
            return "Icon1"
        case .blue:
            return "Icon2"
        case .yellow:
            return "Icon3"
        case .green:
            return "Icon4"
        case .violet:
            return "Icon5"
        }
    }

    var color: Color {
        switch self {
        case .blackDefault:
            return .black
        case .pink:
            return .pinkTapBar
        case .blue:
            return .sommeil
        case .yellow:
            return .couche
        case .green:
            return .repas
        case .violet:
            return .croissance
        }
    }
}
