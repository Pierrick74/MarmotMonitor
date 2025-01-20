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

    // MARK: - Singleton
    static let shared = StartupManager(storageManager: AppStorageManager.shared)

    // MARK: - Dependencies
    private var storageManager: AppStorageManagerProtocol

    // MARK: - Init
    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
        isOnBoardingFinished = storageManager.isOnBoardingFinished
    }

    // MARK: - Published Properties
    @Published var isOnBoardingFinished: Bool {
        didSet { storageManager.isOnBoardingFinished = isOnBoardingFinished }
    }

    // MARK: - Functions
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
