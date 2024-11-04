//
//  StartupManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI

// This class will manage the onboarding process
// It will be used to determine if user have already seen the onboarding screen
// Data will be stored in AppStorage

final class StartupManager: ObservableObject {

    enum CurrentState {
        case running
        case onBoarding
    }

    private var storageManager: AppStorageManagerProtocol

    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
    }

    var isOnBoardingFinished: Bool {
        storageManager.isOnBoardingFinished
    }

    func onBoardingFinished() {
        storageManager.isOnBoardingFinished = true
    }

}
