//
//  ActivityError.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2024.
//

import Foundation

enum ActivityError: Error, LocalizedError {
    case overlappingActivity

    var errorDescription: String? {
        switch self {
        case .overlappingActivity:
            return "Une activité est déja enregistrée à cette date"
        }
    }
}
