//
//  MainTabView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI

struct MainTabView: View {
    private let gender = AppStorageManager.shared.gender
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
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
                Spacer()
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
            .overlay(VStack {
                Spacer()
                NavigationLink(destination: AddView()
                    .navigationTransition(.zoom(sourceID: "zoom", in: namespace))) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(10)
                        .background(Circle().fill(colorScheme == .dark ? Color.black : Color.white))
                        .padding(10)
                        .matchedTransitionSource(id: "zoom", in: namespace)
                }
            }
            )
        }
    }
}

#Preview {
    MainTabView()
}
