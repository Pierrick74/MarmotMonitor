//
//  OnBoardingManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 30/10/2024.
//

import Foundation

final class OnBoardingManager: ObservableObject {

    enum Screen: Int, CaseIterable {
        case welcome
        case babyName
        case gender
        case parentName
        case birthDate
    }

    @Published var activeScreen: Int = Screen.allCases.first!.rawValue

    func previous() {
        let previousScreenIndex = max(activeScreen - 1, Screen.allCases.first!.rawValue)
        activeScreen = previousScreenIndex
    }

    func next() {
        let nextScreenIndex = min(activeScreen + 1, Screen.allCases.last!.rawValue)
        activeScreen = nextScreenIndex
    }
}
