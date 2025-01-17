//
//  GenderButton.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 17/01/2025.
//

import SwiftUI

/// A reusable button for selecting a specific gender type.
/// - Parameters:
///   - type: The `GenderType` this button represents.
///   - selection: The current gender selection.
///   - action: A closure executed when the button is tapped.
/// - Returns: A stylized button for selecting a gender.
struct GenderButton: View {
    @Environment(\.colorScheme) var colorScheme

    let type: GenderType
    let selection: GenderType
    let action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) { action() }
        }, label: {
            HStack {
                Image(type == .boy ? .boy : .girl)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .opacity(selection == type ? 1 : 0.5)
                Text(type.rawValue)
                    .font(.body.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        selection == type
                        ? (type == .boy ? .boyGenderButton : .girlGenderButton)
                            : (type == .boy ? .boyGenderButton.opacity(0.4) : .girlGenderButton.opacity(0.4))
                    )
                    .shadow(color: selection == type ?
                            colorScheme == .light ? .primary : .clear
                            : .clear, radius: 2, x: 0, y: 2)
            )
        })
        .foregroundColor(selection == type ? .primary : .primary.opacity(0.7))
    }
}

#Preview {
    GenderButton(type: .boy, selection: .girl, action: { })
}
