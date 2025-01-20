//
//  InformationViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI
/// Manager for the information view in setupProfile
/// This class is responsible for managing the data of the information view
class InformationViewManager: ObservableObject {
    @Published var name: String
    @Published var parentName: String
    @Published var babyBirthday = Date()
    @Published var gender: GenderType

    var dataManager: AppStorageManagerProtocol

    init(dataManager: AppStorageManagerProtocol = AppStorageManager.shared) {
        self.dataManager = dataManager
        name = dataManager.babyName
        babyBirthday = dataManager.babyBirthday
        gender = dataManager.gender
        parentName = dataManager.parentName
    }

    func saveInformation() {
        dataManager.babyName = name
        dataManager.babyBirthday = babyBirthday
        dataManager.setGender(with: gender)
        dataManager.parentName = parentName
    }
}
