//
//  StartupView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI

struct StartupView: View {

    @StateObject var startupManager = StartupManager()

    var body: some View {
        VStack {
            if startupManager.isOnBoardingFinished {
                MainView()
            } else {
                OnBoardingView()
            }
        }
    }
}

#Preview {
    StartupView()
}
