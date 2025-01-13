//
//  FilterButton.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//

import SwiftUI

/// A button to filter activities by category.
/// - Parameters:
///  - category: The category of the activity.
///  - isSelected: A boolean value indicating whether the filter is selected.
///  - action: The action to perform when the button is tapped.
///  - Returns: A SwiftUI `View` for filtering activities.
struct FilterButton: View {
    let category: ActivityCategory
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
                action()
        }, label: {
            Image(category.rawValue)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(10)
                .background(
                    Circle()
                        .fill(isSelected ? category.color : .gray)
                        .shadow(color: .primary, radius: 2)
                )
                .frame(maxWidth: .infinity)
        })
        .accessibilityLabel("Filtre \(category.rawValue) \(isSelected ? "activé" : "désactivé")")
    }
}

#Preview {
    FilterButton(category: .sleep, isSelected: true, action: {})
}
