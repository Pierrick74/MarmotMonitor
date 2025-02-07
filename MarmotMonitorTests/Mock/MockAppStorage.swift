//
//  MockAppStorage.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 29/11/2024.
//

import SwiftUI
@testable import MarmotMonitor

// MARK: - Mock For Tests

class MockAppStorageManager: AppStorageManagerProtocol {
    var processCompletedCount: Int = 0
    var lastDateForReview: Date?
    var appearance: MarmotMonitor.Appearance = .system
    var gender: MarmotMonitor.GenderType = .girl
    func setGender(with gender: MarmotMonitor.GenderType) { self.gender = gender}
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var babyBirthday: Date = Date()
    var isMetricUnit: Bool = true
    var picture: String = ""
    func saveImageToAppStorage(_ image: UIImage) {}
    func loadImageFromAppStorage() -> UIImage? { return nil }
}

class MockAppStorageManagerForStripName: AppStorageManagerProtocol {
    var processCompletedCount: Int = 0
    var lastDateForReview: Date?
    var appearance: MarmotMonitor.Appearance = .system
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var gender: MarmotMonitor.GenderType = .girl
    var babyBirthday: Date = Date.init(timeIntervalSinceNow: -8952485962)
    var isMetricUnit: Bool = true
    func setGender(with gender: MarmotMonitor.GenderType) { self.gender = gender}
    var picture: String = ""
    func saveImageToAppStorage(_ image: UIImage) {}
    func loadImageFromAppStorage() -> UIImage? { return nil }
}

class MockAppStorageManagerInImperial: AppStorageManagerProtocol {
    var processCompletedCount: Int = 0
    var lastDateForReview: Date?
    var appearance: MarmotMonitor.Appearance = .system
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var gender: MarmotMonitor.GenderType = .girl
    var babyBirthday: Date = Date()
    var isMetricUnit: Bool = false
    func setGender(with gender: MarmotMonitor.GenderType) { self.gender = gender}
    var picture: String = ""
    func saveImageToAppStorage(_ image: UIImage) {}
    func loadImageFromAppStorage() -> UIImage? { return nil }
}
