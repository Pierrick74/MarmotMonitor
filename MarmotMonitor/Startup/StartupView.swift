//
//  StartupView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI
// entry point of the app
// This view will determine if the user has already seen the onboarding screen

struct StartupView: View {

    @StateObject var startupManager = StartupManager.shared

    var body: some View {
        VStack {
            if startupManager.isOnBoardingFinished {
                MainTabView()
            } else {
                OnBoardingView()
            }
        }
    }
}

#Preview {
    StartupView()
}
