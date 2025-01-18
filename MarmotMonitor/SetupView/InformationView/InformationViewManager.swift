//
//  InformationViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI
/// Manager for the information view
/// This class is responsible for managing the data of the information view
class InformationViewManager: ObservableObject {
    @Published var name: String
    @Published var parentName: String
    @Published var babyBirthday = Date()
    @Published var gender: GenderType

    var dataStorage = AppStorageManager.shared

    init() {
        name = dataStorage.babyName
        babyBirthday = dataStorage.babyBirthday
        gender = dataStorage.gender
        parentName = dataStorage.parentName
    }

    func saveInformation() {
        dataStorage.babyName = name
        dataStorage.babyBirthday = babyBirthday
        dataStorage.setGender(with: gender)
        dataStorage.parentName = parentName
    }
}
