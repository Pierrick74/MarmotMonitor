//
//  ModeButton.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/12/2024.
//

import SwiftUI

/// View that represents a mode button
/// Parameters:
/// - imageName: the name of the image to display
/// - isSelected: true if the mode is selected
/// - isDisabled: true if the mode is disabled
/// - action: the action to perform when the button is tapped
struct ModeButton: View {
    let imageName: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            Image(decorative: imageName)
                .resizable()
                .scaledToFit()
                .shadow(color: .primary.opacity(0.5), radius: 10, x: 0, y: 0)
                Button(action: action) {
                    Image(systemName: isSelected ? "record.circle" : "circle")
                        .padding()
                        .foregroundColor(.primary)
                }
                .accessibilityLabel("Mode \(imageName) \(isSelected ? "activé" : "désactivé")")
                .accessibilityHint("Appuyer pour changer le mode si la synchronisation systeme n'est pas activée")
                .disabled(isDisabled)
                .opacity(isDisabled ? 0 : 1)
        }
    }
}

#Preview {
    ModeButton(imageName: "darkMode", isSelected: true, isDisabled: true, action: {})
}
