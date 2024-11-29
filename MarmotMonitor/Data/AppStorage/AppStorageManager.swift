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
    var gender: String { get set }
    var babyBirthday: Date { get set }
    var isMetricUnit: Bool { get set }
}

// MARK: - AppStorageManager
final class AppStorageManager: AppStorageManagerProtocol {

    enum AppStorageKeys: String {
        case isOnBoardingFinished
        case babyName
        case parentName
        case gender
        case babyBirthday
        case isMetricUnit
    }

    @AppStorage(AppStorageKeys.gender.rawValue) var gender: String = GenderType.boy.rawValue
    @AppStorage(AppStorageKeys.babyName.rawValue) var babyName: String = ""
    @AppStorage(AppStorageKeys.parentName.rawValue) var parentName: String = ""
    @AppStorage(AppStorageKeys.isOnBoardingFinished.rawValue) var isOnBoardingFinished: Bool = false
    @AppStorage(AppStorageKeys.babyBirthday.rawValue) var babyBirthday: Date = Date()
    @AppStorage(AppStorageKeys.isMetricUnit.rawValue) var isMetricUnit: Bool = true

    static let shared = AppStorageManager()
}

// MARK: - Mock For Tests

class MockAppStorageManager: AppStorageManagerProtocol {
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var gender: String = "girl"
    var babyBirthday: Date = Date()
    var isMetricUnit: Bool = true
}

class MockAppStorageManagerForStripName: AppStorageManagerProtocol {
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var gender: String = "girl"
    var babyBirthday: Date = Date.init(timeIntervalSinceNow: -8952485962)
    var isMetricUnit: Bool = true
}
