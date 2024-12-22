//
//  ModeButton.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/12/2024.
//

import SwiftUI

struct ModeButton: View {
    let imageName: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .shadow(color: .primary.opacity(0.5), radius: 10, x: 0, y: 0)

            Button(action: action) {
                Image(systemName: isSelected ? "record.circle" : "circle")
                    .padding()
                    .foregroundColor(.primary)
            }
            .disabled(isDisabled)
        }
    }
}

#Preview {
    ModeButton(imageName: "darkMode", isSelected: true, isDisabled: false, action: {})
}
