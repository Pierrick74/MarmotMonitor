//
//  GrowthAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI

@MainActor
final class GrowthAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    var range: ClosedRange<Date> {
        Date.distantPast...Date.now
    }

    @Published var date: Date?

    @Published var size: Double?
    var sizeDescription: String? {
        (size != nil) ? "\(size!) cm" : nil
    }

    @Published var weight: Double?
    var weightDescription: String? {
        (weight != nil) ? "\(weight!) kg" : nil
    }

    @Published var headSize: Double?
    var headSizeDescription: String? {
        (headSize != nil) ? "\(headSize!) cm" : nil
    }
}
