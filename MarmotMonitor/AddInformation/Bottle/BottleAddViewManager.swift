//
//  BottleAddViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/11/2024.
//

import SwiftUI

@MainActor
final class BottleAddViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared

    @Published var percent: Double = 20.0 {
        didSet {
            self.volume = "\(Int(percent * 3.6))" + " ml"
        }
    }

    @Published var volume: String = "72" + " ml"

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
    }

    func setPercent(_ amount: Double) {
        self.percent = amount
    }
}
