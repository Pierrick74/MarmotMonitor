//
//  Appearance.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 14/12/2024.
//

import SwiftUI

enum Appearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { self.rawValue }

    // Map Appearance cases to SwiftUI's ColorScheme
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil // Follow system
        case .light: return .light
        case .dark: return .dark
        }
    }
}
