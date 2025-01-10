//
//  SaveButtonView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI
/// A reusable save button view.
///
/// Displays a button with a text label or an icon, depending on the dynamic type size.
/// The button triggers a save action passed via a closure.
///
/// - Parameters:
///   - onSave: A closure executed when the button is tapped.
/// - Returns: A button styled for save actions.
struct SaveButtonView: View {
    var onSave: () -> Void
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onSave ) {
                if dynamicTypeSize >= .accessibility1 {
                    Image(systemName: "checkmark")
                } else {
                    Text("Sauvegarder")
                }
            }
            .buttonStyle(CustomSaveButtonStyle())
            .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
        }
        .padding([.bottom, .horizontal], 20)
    }
}

#Preview {
    SaveButtonView(onSave: {})
}
