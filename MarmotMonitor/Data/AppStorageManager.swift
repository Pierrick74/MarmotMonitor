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
}

// MARK: - AppStorageManager
final class AppStorageManager: AppStorageManagerProtocol {

    enum AppStorageKeys: String {
        case isOnBoardingFinished
        case babyName
        case parentName
        case gender
        case babyBirthday
    }

    @AppStorage(AppStorageKeys.gender.rawValue) var gender: String = GenderType.boy.rawValue
    @AppStorage(AppStorageKeys.babyName.rawValue) var babyName: String = ""
    @AppStorage(AppStorageKeys.parentName.rawValue) var parentName: String = ""
    @AppStorage(AppStorageKeys.isOnBoardingFinished.rawValue) var isOnBoardingFinished: Bool = false
    @AppStorage(AppStorageKeys.babyBirthday.rawValue) var babyBirthday: Date = Date()

    static let shared = AppStorageManager()
}

// MARK: - Mock For Tests

class MockAppStorageManager: AppStorageManagerProtocol {
    var babyName: String = ""
    var isOnBoardingFinished: Bool = false
    var parentName: String = ""
    var gender: String = "girl"
    var babyBirthday: Date = Date()
}
