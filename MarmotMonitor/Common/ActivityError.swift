//
//  ActivityError.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2024.
//

import Foundation
/// Enum for ActivityError
/// - overlappingActivity: Error when two activities are overlapping
enum ActivityError: Error, LocalizedError {
    case overlappingActivity

    var errorDescription: String? {
        switch self {
        case .overlappingActivity:
            return "Une activité est déja enregistrée à cette date"
        }
    }
}
