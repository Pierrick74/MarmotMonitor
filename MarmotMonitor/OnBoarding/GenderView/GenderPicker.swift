//
//  GenderPicker.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/11/2024.
//
//

import SwiftUI
// Custom segmented picker to select the Gender of the baby
// This view is used in the GenderView
// User can select between "Garçon" and "Fille"
// Use GenderType.rawValue to get the selected value

struct GenderPicker: View {
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 10) {
            GenderButton(
                type: .boy,
                selection: selection,
                action: { selection = GenderType.boy.rawValue }
            )

            GenderButton(
                type: .girl,
                selection: selection,
                action: { selection = GenderType.girl.rawValue }
            )
        }
        .padding(5)
    }
}

struct GenderButton: View {
    @Environment(\.colorScheme) var colorScheme

    let type: GenderType
    let selection: String
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
                    .opacity(selection == type.rawValue ? 1 : 0.5)
                Text(type.rawValue)
                    .font(.body)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        selection == type.rawValue
                        ? (type == .boy ? .boyGenderButton : .girlGenderButton)
                            : (type == .boy ? .boyGenderButton.opacity(0.2) : .girlGenderButton.opacity(0.2))
                    )
                    .shadow(color: selection == type.rawValue ?
                            colorScheme == .light ? .primary : .clear
                            : .clear, radius: 2, x: 0, y: 2)
            )
        })
        .foregroundColor(selection == type.rawValue ? .primary : .primary.opacity(0.5))
    }
}

#Preview {
    GenderPicker(selection: .constant(GenderType.boy.rawValue))
        .padding()
}
