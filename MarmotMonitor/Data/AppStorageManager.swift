//
//  AppStorageKeys.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 30/10/2024.
//

import SwiftUI

// MARK: - AppStorageManagerProtocol
protocol AppStorageManagerProtocol {
    var babyName: String { get set }
    var isOnBoardingFinished: Bool { get set }
    var parentName: String { get set }
}

// MARK: - AppStorageManager
final class AppStorageManager: AppStorageManagerProtocol {

    enum AppStorageKeys: String {
        case isOnBoardingFinished
        case babyName
        case parentName
    }

    @AppStorage(AppStorageKeys.babyName.rawValue) var babyName: String = ""
    @AppStorage(AppStorageKeys.parentName.rawValue) var parentName: String = ""
    @AppStorage(AppStorageKeys.isOnBoardingFinished.rawValue) var isOnBoardingFinished: Bool = false

    static let shared = AppStorageManager()
}

// MARK: - Mock For Tests

class MockAppStorageManager: AppStorageManagerProtocol {
    var babyName: String = ""
    var isOnBoardingFinished: Bool = false
    var parentName: String = ""
}
