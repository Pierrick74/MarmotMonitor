//
//  GenderPicker.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/11/2024.
//
//

import SwiftUI
/// A view that allows the user to pick a gender using two buttons.
/// - Parameters:
///   - selection: A binding to the currently selected `GenderType`.
/// - Returns: A horizontal stack of gender selection buttons.
struct GenderPicker: View {
    @Binding var selection: GenderType

    var body: some View {
        HStack(spacing: 10) {
            GenderButton(
                type: .boy,
                selection: selection,
                action: { selection = GenderType.boy }
            )
            .accessibilityHint("Séléctionné", isEnabled: selection == GenderType.boy)

            GenderButton(
                type: .girl,
                selection: selection,
                action: { selection = GenderType.girl }
            )
            .accessibilityHint("Séléctionné", isEnabled: selection == GenderType.girl)
        }
        .padding(5)
    }
}

#Preview {
    GenderPicker(selection: .constant(GenderType.boy))
        .padding()
}
