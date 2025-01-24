//
//  MainTabView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI
import StoreKit
/// The main tab-based interface of the app, providing navigation to key sections.
/// - Includes tabs for Today, Monitor, Growth, and Setup.
/// - Offers a central button for adding new entries.
struct MainTabView: View {
    // MARK: - Dependencies
    @ObservedObject private var manager = AppStorageManager.shared
    @ObservedObject private var reviewManager = ReviewManager.shared

    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.requestReview) var requestReview
    @Namespace private var namespace
    @State private var isPresented: Bool = false
    @State private var isShowingReview: Bool = false

    var body: some View {
        NavigationStack {
            TabView {
                todayTab
                monitorTab
                Spacer()
                growthTab
                setupTab
            }
            .tint(manager.gender == GenderType.boy ? .blueTapBar : .pinkTapBar)
            .onAppear(perform: configureTabBarAppearance)
            .overlay(addButtonOverlay)
            .sheet(isPresented: $isPresented) {
                AddView()
                    .navigationTransition(.zoom(sourceID: "zoom", in: namespace))
                .presentationCornerRadius(30)
                .environment(\.dynamicTypeSize, dynamicTypeSize)
            }
            .onChange(of: isShowingReview) { _, newValue in
                if newValue == true {
                    Task {
                        try await Task.sleep(until: .now + .seconds(2))
                        requestReview()
                    }
                }
            }
        }
    }

    // MARK: - Private Views
    private var todayTab: some View {
        TodayView()
            .tabItem {
                Label("Auj", systemImage: "calendar")
                    .accessibility(label: Text("Aujourd'hui"))
                    .accessibilityHint("Synthèse de la journée")
            }
    }

    private var monitorTab: some View {
        MonitorView()
            .tabItem {
                Label("Monitor", systemImage: "waveform.path.ecg")
            }
    }

    private var growthTab: some View {
        GrowthView()
            .tabItem {
                Label("Docteur", systemImage: "stethoscope")
            }
    }

    private var setupTab: some View {
        SetupView()
            .tabItem {
                Label("Réglages", systemImage: "gear")
            }
    }

    // MARK: - Helpers

    /// Configures the appearance of the tab bar.
    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.label
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }

    // MARK: - Overlay

    /// The floating button overlay for adding new entries.
    var addButtonOverlay: some View {
        VStack {
            Spacer()
            Button(action: {
                isPresented.toggle()
                isShowingReview = reviewManager.checkForReview()
            }, label: {
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
    }
}

#Preview {
    MainTabView()
}
