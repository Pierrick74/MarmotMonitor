//
//  AppIconTheme.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/12/2024.
//

import SwiftUI

/// Enum that represents the different app icon themes
enum AppIconTheme: String, CaseIterable {
    case blackDefault = "black"
    case pink = "pink"
    case blue = "blue"
    case yellow = "yellow"
    case green = "green"
    case violet = "violet"

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
