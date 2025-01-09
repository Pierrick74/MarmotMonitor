//
//  TodayViewManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2024.
//

import SwiftUI
import PhotosUI

@MainActor
final class TodayViewManager: ObservableObject {
    private var dataManager: SwiftDataManagerProtocol = SwiftDataManager.shared
    private var storageManager: AppStorageManagerProtocol = AppStorageManager.shared

    @Published var lastSleepActivity: BabyActivity?
    @Published var lastDiaperActivity: BabyActivity?
    @Published var lastFoodActivity: BabyActivity?
    @Published var lastGrowthActivity: BabyActivity?

    @Published var selectedImage: Image = Image("todayDefault")

    init(dataManager: SwiftDataManagerProtocol? = nil) {
        if let dataManager = dataManager {
            self.dataManager = dataManager
        }
        refreshData()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataUpdate),
            name: .dataUpdated,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Functions
    private func getLastActivity(of category: ActivityCategory) -> BabyActivity? {
        let activities = dataManager.fetchFilteredActivities(with: [category])
        return activities.first
    }

    func refreshData() {
        lastSleepActivity = getLastActivity(of: .sleep)
        lastDiaperActivity = getLastActivity(of: .diaper)
        lastFoodActivity = getLastActivity(of: .food)
        lastGrowthActivity = getLastActivity(of: .growth)

        initSelectedImage()
    }

    private func initSelectedImage() {
        if let picture = storageManager.loadImageFromAppStorage() {
            selectedImage = Image(uiImage: picture)
        } else {
            selectedImage = Image("todayDefault")
        }
    }

    func changePicture(_ picture: PhotosPickerItem?) {
        if let picture {
            Task {
                if let image = await picture.convert() {
                    selectedImage = Image(uiImage: image)
                    storageManager.saveImageToAppStorage(image)
                } else {
                    selectedImage = Image("todayDefault")
                }
            }
        }
    }

    @objc private func handleDataUpdate(_ notification: Notification) {
        refreshData()
    }
}
