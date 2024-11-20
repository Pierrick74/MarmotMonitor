//
//  SwiftDataManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI
import SwiftData

// MARK: - AppStorageManagerProtocol
protocol SwiftDtaManagerProtocol {
}

// MARK: - AppStorageManager
final class SwiftDataManager: SwiftDtaManagerProtocol {
    @Environment(\.modelContext) var modelContext
    var babyActivity: [BabyActivity] = []

    static let shared = SwiftDataManager()

    init() {
        fetchData()
    }

    func fetchData() {
        do {
            let descriptor = FetchDescriptor<BabyActivity>(sortBy: [SortDescriptor(\.date, order: .forward)])
            babyActivity = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }

}
