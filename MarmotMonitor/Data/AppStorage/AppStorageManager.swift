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
    func setGender(with gender: GenderType)
    func saveImageToAppStorage(_ image: UIImage)
    func loadImageFromAppStorage() -> UIImage?
}

// MARK: - AppStorageManager
final class AppStorageManager: AppStorageManagerProtocol, ObservableObject {

    enum AppStorageKeys: String {
        case isOnBoardingFinished
        case babyName
        case parentName
        case gender
        case babyBirthday
        case isMetricUnit
        case appearance
        case picture
    }
    @Published private(set) var gender: GenderType = GenderType.boy

    @AppStorage(AppStorageKeys.gender.rawValue) private var storageGender: String = GenderType.boy.rawValue
    @AppStorage(AppStorageKeys.babyName.rawValue) var babyName: String = ""
    @AppStorage(AppStorageKeys.parentName.rawValue) var parentName: String = ""
    @AppStorage(AppStorageKeys.isOnBoardingFinished.rawValue) var isOnBoardingFinished: Bool = false
    @AppStorage(AppStorageKeys.babyBirthday.rawValue) var babyBirthday: Date = Date()
    @AppStorage(AppStorageKeys.isMetricUnit.rawValue) var isMetricUnit: Bool = true
    @AppStorage(AppStorageKeys.appearance.rawValue) var appearance: Appearance = .system
    @AppStorage(AppStorageKeys.picture.rawValue) var picture: String = ""

    static let shared = AppStorageManager()

    func setGender(with gender: GenderType) {
        self.gender = gender
        storageGender = gender.rawValue
    }

    init() {
        self.gender = GenderType(rawValue: storageGender) ?? GenderType.boy
    }

    func saveImageToAppStorage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            picture = imageData.base64EncodedString()
            print("Image sauvegardée dans AppStorage")
        }
    }

    func loadImageFromAppStorage() -> UIImage? {
        if let imageData = Data(base64Encoded: picture),
           let uiImage = UIImage(data: imageData) {
            return uiImage
        }
        return nil
    }
}

// MARK: - Mock For Tests

class MockAppStorageManager: AppStorageManagerProtocol {
    var appearance: Appearance = .dark
    func setGender(with gender: GenderType) {}
    var babyName: String = "Line"
    var isOnBoardingFinished: Bool = false
    var parentName: String = "Pierrick"
    var gender: GenderType = .girl
    var babyBirthday: Date = Date()
    var isMetricUnit: Bool = true
    var picture: String = ""
    func saveImageToAppStorage(_ image: UIImage) {}
    func loadImageFromAppStorage() -> UIImage? { return nil }
}

class MockAppStorageManagerForStripName: AppStorageManagerProtocol {
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
