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
            valideBabyName = trimmed.count < 2 ? false : true
        }
    }

    @Published var valideBabyName: Bool?

}

extension OnBoardingManager {
    enum Screen: Int, CaseIterable {
        case welcome
        case babyName
        case gender
        case parentName
        case birthDate

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
            case .birthDate:
                return "date de naissance"
            }
        }
    }
}
