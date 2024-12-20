//
//  OnBoardingManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 30/10/2024.
//

import SwiftUI
// manage de obBoarding screen
// store the activeScreen index
// manage the previous and next button

final class OnBoardingManager: ObservableObject {

    private var storageManager: AppStorageManagerProtocol

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
        get { storageManager.babyName }
        set {
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            storageManager.babyName = trimmed.count < 2 ? "" : trimmed
            isBabyNameValide = trimmed.count < 2 ? false : true
        }
    }

    @Published var isBabyNameValide: Bool?

    // MARK: - Parent Name
    var parentName: String {
        get { storageManager.parentName }
        set {
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            storageManager.parentName = trimmed.count < 2 ? "" : trimmed
            isParentNameValide = trimmed.count < 2 ? false : true
        }
    }

    @Published var isParentNameValide: Bool?

    // MARK: - Gender
    @Published var gender: String {
        didSet {
            storageManager.gender = gender
        }
    }

    // MARK: - BirthDay
    @Published var babyBirthday: Date {
        didSet { storageManager.babyBirthday = babyBirthday
        }
    }
}

extension OnBoardingManager {
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
