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

    static let shared = StartupManager(storageManager: AppStorageManager.shared)

    private var storageManager: AppStorageManagerProtocol

    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
        isOnBoardingFinished = storageManager.isOnBoardingFinished
    }

    @Published var isOnBoardingFinished: Bool {
        didSet { storageManager.isOnBoardingFinished = isOnBoardingFinished }
    }

    func onBoardingFinished() {
        withAnimation {
            isOnBoardingFinished = true
        }
    }

    enum CurrentState {
        case running
        case onBoarding
    }
}
