//
//  MainTabView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject private var manager = AppStorageManager.shared
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Namespace private var namespace
    @State private var isPresented: Bool = false

    var body: some View {
        NavigationStack {
            TabView {
                TodayView()
                    .tabItem {
                        Label("Auj", systemImage: "calendar")
                            .accessibility(label: Text("Aujourd'hui"))
                            .accessibilityHint("Synthèse de la journée")
                    }
                MonitorView()
                    .tabItem {
                        Label("Monitor", systemImage: "waveform.path.ecg")
                    }
                Spacer()
                GrowthView()
                    .tabItem {
                        Label("Docteur", systemImage: "stethoscope")
                    }
                SetupView()
                    .tabItem {
                        Label("Réglage", systemImage: "gear")
                    }
            }
            .tint(manager.gender == GenderType.boy ? .blueTapBar : .pinkTapBar)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor.label
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]

                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().isTranslucent = false
                UITabBar.appearance().backgroundColor = UIColor.systemBackground
            }
            .overlay(VStack {
                Spacer()
                Button(action: { isPresented.toggle() },
                       label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .background(
                            manager.gender == .boy ? Color.pastelBlueToEgiptienBlue.mix(with: .black, by: 0.1)
                            : Color.pinkToEgiptienBlue.mix(with: .black, by: 0.1))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(10)
                        .background(Circle().fill(colorScheme == .dark ? Color.black : Color.white))
                        .padding(5)
                        .matchedTransitionSource(id: "zoom", in: namespace)
                })
            }
            )
            .sheet(isPresented: $isPresented) {
                AddView()
                    .navigationTransition(.zoom(sourceID: "zoom", in: namespace))
                .presentationCornerRadius(30)
                .environment(\.dynamicTypeSize, dynamicTypeSize)
            }
        }
    }
}

#Preview {
    MainTabView()
}
