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
                }
            Text("First View")
                .tabItem {
                    Label("Monitor", systemImage: "waveform.path.ecg")
                }
            Text("First View")
                .tabItem {
                    Label("Docteur", systemImage: "stethoscope")
                }
            Text("First View")
                .tabItem {
                    Label("Réglage", systemImage: "gear")
                }
        }
        .tint(gender == GenderType.boy.rawValue ? .blueTapBar : .pinkTapBar)
    }
}

#Preview {
    MainTabView()
}
