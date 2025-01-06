//
//  AccessibilityItemView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/11/2024.
//

import SwiftUI

/// A SwiftUI view representing an accessibility-friendly item for a grid layout.
/// - Parameters:
///   - item: An instance of `GridItemData` containing the icon, text, color, and destination.
///
/// This view displays a rounded rectangle with an icon and text, providing a visually appealing and accessible design.
struct AccessibilityItemView: View {
    let item: GridItemData

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .fill(item.color)
            HStack {
                Image(decorative: item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.top, 5)
                Text(item.text)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                    .accessibilityHint("insérer les informations pour \(item.text)")
            }
        }
    }
}

#Preview {
    AccessibilityItemView(
        item: GridItemData(
            icon: "Sommeil",
            text: "Sommeil",
            color: .sommeil,
            destination: .sommeil
        )
    )
}
