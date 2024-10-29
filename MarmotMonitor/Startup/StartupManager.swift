//
//  StartupManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI

final class StartupManager: ObservableObject {

    enum CurrentState {
        case running
        case onBoarding
    }

    @AppStorage("isOnBoardingFinished") private(set) var isOnBoardingFinished: Bool = false

        func onBoardingFinished() {
            isOnBoardingFinished = true
        }
}
