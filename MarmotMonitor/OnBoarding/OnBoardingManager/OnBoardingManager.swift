//
//  OnBoardingManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 30/10/2024.
//

import SwiftUI

/// Manages the onboarding process, including screen navigation and user inputs.
/// - Handles persistence through `AppStorageManagerProtocol`.
/// - Publishes states for binding with SwiftUI views.
final class OnBoardingManager: ObservableObject {

    // MARK: - Dependencies
    private var storageManager: AppStorageManagerProtocol

    // MARK: - Initializers
    init(storageManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.storageManager = storageManager
        gender = storageManager.gender
        babyBirthday = storageManager.babyBirthday
    }

    // MARK: - Screen manager
    @Published var activeScreen: Int = Screen.allCases.first!.rawValue

    func previous() {
        let previousScreenIndex = max(activeScreen - 1, Screen.allCases.first!.rawValue)
        withAnimation {
            activeScreen = previousScreenIndex
        }
    }

    func next() {
        guard activeScreen != Screen.allCases.last!.rawValue else {
            StartupManager.shared.onBoardingFinished()
            return
        }

        let nextScreenIndex = min(activeScreen + 1, Screen.allCases.last!.rawValue)
        withAnimation(.easeInOut) {
            activeScreen = nextScreenIndex
        }
    }

    // MARK: - Baby Name
    var babyName: String {
        get { rawBabyName }
        set {
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            rawBabyName = trimmed
            isBabyNameValide = trimmed.count >= 2
            if isBabyNameValide == true {
                storageManager.babyName = trimmed
            }
        }
    }
    @Published private var rawBabyName: String = ""
    @Published var isBabyNameValide: Bool = false

    // MARK: - Parent Name
    var parentName: String {
        get { rawParentName }
        set {
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            rawParentName = trimmed
            isParentNameValide = trimmed.count >= 2
            if isParentNameValide == true {
                storageManager.parentName = trimmed
            }
        }
    }
    @Published private var rawParentName: String = ""
    @Published var isParentNameValide: Bool = false

    // MARK: - Gender
    @Published var gender: GenderType {
        didSet {
            storageManager.setGender(with: gender)
        }
    }

    // MARK: - BirthDay
    @Published var babyBirthday: Date {
        didSet { storageManager.babyBirthday = babyBirthday
        }
    }
}

extension OnBoardingManager {
    /// Represents the onboarding screens
    enum Screen: Int, CaseIterable {
        case welcome
        case babyName
        case gender
        case parentName
        case babyBirthday

        var title: String {
            switch self {
            case .welcome:
                return "Bonjour"
            case .babyName:
                return "Nom du bébé"
            case .gender:
                return "genre du bébé"
            case .parentName:
                return "nom des parents"
            case .babyBirthday:
                return "date de naissance"
            }
        }
    }
}
