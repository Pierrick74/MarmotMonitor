//
//  MainTabView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI

struct MainTabView: View {
    private let gender = AppStorageManager.shared.gender

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Auj", systemImage: "calendar")
                        .accessibility(label: Text("Aujourd'hui"))
                        .accessibilityHint("Synthèse de la journée")
                }
            Text("Version 2")
                .tabItem {
                    Label("Monitor", systemImage: "waveform.path.ecg")
                }
            Text("Version 2")
                .tabItem {
                    Label("Docteur", systemImage: "stethoscope")
                }
            TodayView()
                .tabItem {
                    Label("Réglage", systemImage: "gear")
                }
        }
        .tint(gender == GenderType.boy.rawValue ? .blueTapBar : .pinkTapBar)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.label
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]
            UITabBar.appearance().standardAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}
