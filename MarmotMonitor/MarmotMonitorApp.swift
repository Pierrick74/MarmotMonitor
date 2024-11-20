//
//  MarmotMonitorApp.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI
import SwiftData

@main
struct MarmotMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            StartupView()
        }
        .modelContainer(for: BabyActivity.self)
    }
}
