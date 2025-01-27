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
    var gender: GenderType { get }
    var babyBirthday: Date { get set }
    var isMetricUnit: Bool { get set }
    var appearance: Appearance { get set }
    var picture: String { get set }
    var processCompletedCount: Int { get set }
    var lastDateForReview: Date? { get set }
    func setGender(with gender: GenderType)
    func saveImageToAppStorage(_ image: UIImage)
    func loadImageFromAppStorage() -> UIImage?
}

// MARK: - AppStorageManager
/// A singleton class for managing app storage using `@AppStorage`.
///
/// Stores and retrieves user preferences and data persistently, including support for images.
final class AppStorageManager: AppStorageManagerProtocol, ObservableObject {
    // MARK: - Enum
    enum AppStorageKeys: String {
        case isOnBoardingFinished
        case babyName
        case parentName
        case gender
        case babyBirthday
        case isMetricUnit
        case appearance
        case picture
        case processCompletedCount
        case lastDateForReview
    }

    // MARK: - Properties
    static let shared = AppStorageManager()

    @Published private(set) var gender: GenderType = GenderType.boy

    @AppStorage(AppStorageKeys.gender.rawValue) private var storageGender: String = GenderType.boy.rawValue
    @AppStorage(AppStorageKeys.babyName.rawValue) var babyName: String = ""
    @AppStorage(AppStorageKeys.parentName.rawValue) var parentName: String = ""
    @AppStorage(AppStorageKeys.isOnBoardingFinished.rawValue) var isOnBoardingFinished: Bool = false
    @AppStorage(AppStorageKeys.babyBirthday.rawValue) var babyBirthday: Date = Date()
    @AppStorage(AppStorageKeys.isMetricUnit.rawValue) var isMetricUnit: Bool = true
    @AppStorage(AppStorageKeys.appearance.rawValue) var appearance: Appearance = .system
    @AppStorage(AppStorageKeys.picture.rawValue) var picture: String = ""
    @AppStorage(AppStorageKeys.processCompletedCount.rawValue) var processCompletedCount: Int = 0
    @AppStorage(AppStorageKeys.lastDateForReview.rawValue) var lastDateForReview: Date?

    // MARK: - Initializer
    init() {
        self.gender = GenderType(rawValue: storageGender) ?? GenderType.boy
    }

    // MARK: - Functions
    /// Sets the user's gender preference and updates the storage.
    /// - Parameter gender: The selected `GenderType`.
    func setGender(with gender: GenderType) {
        self.gender = gender
        storageGender = gender.rawValue
    }

    /// Saves a `UIImage` to app storage as a base64-encoded string.
    /// - Parameter image: The image to save.
    func saveImageToAppStorage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            picture = imageData.base64EncodedString()
            print("Image sauvegardée dans AppStorage")
        }
    }

    /// Loads a `UIImage` from app storage.
    /// - Returns: The loaded `UIImage`, or `nil` if no image exists or decoding fails.
    func loadImageFromAppStorage() -> UIImage? {
        if let imageData = Data(base64Encoded: picture),
           let uiImage = UIImage(data: imageData) {
            return uiImage
        }
        return nil
    }
}

// MARK: - Mock For Tests
class MockAppStorageManagerForStripName: AppStorageManagerProtocol {
    var processCompletedCount: Int = 0
    var lastDateForReview: Date?
    var appearance: Appearance = .dark
    func setGender(with gender: GenderType) {}
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var gender: GenderType = .girl
    var babyBirthday: Date = Date.init(timeIntervalSinceNow: -8952485962)
    var isMetricUnit: Bool = true
    var picture: String = ""
    func saveImageToAppStorage(_ image: UIImage) {}
    func loadImageFromAppStorage() -> UIImage? { return nil }
}
