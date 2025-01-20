//
//  photoPicker.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/11/2024.
//

import PhotosUI
import SwiftUI

extension PhotosPickerItem {
    /// Load and return an image from a PhotosPickerItem
    /// - Returns: The image if it exists
    /// - Throws: An error if the image can't be loaded
    @MainActor
    func convert() async -> UIImage? {
        do {
            // load attend que l'image soit en mémoire pour la convertir
            if let data = try await self.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    return uiImage
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
