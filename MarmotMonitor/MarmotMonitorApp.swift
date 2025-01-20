//
//  MarmotMonitorApp.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI
import SwiftData
/// Entry point of the application
@main
struct MarmotMonitorApp: App {
    @AppStorage("appearance") private var appearance: Appearance = .system

    var body: some Scene {
        WindowGroup {
            StartupView()
                .preferredColorScheme(appearance.colorScheme)
        }
        .modelContainer(for: BabyActivity.self)
    }
}
