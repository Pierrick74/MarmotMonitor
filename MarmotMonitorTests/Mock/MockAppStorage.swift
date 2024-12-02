//
//  MockAppStorage.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 29/11/2024.
//

import Foundation
@testable import MarmotMonitor

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

class MockAppStorageManagerInImperial: AppStorageManagerProtocol {
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var gender: String = "girl"
    var babyBirthday: Date = Date()
    var isMetricUnit: Bool = false
}
