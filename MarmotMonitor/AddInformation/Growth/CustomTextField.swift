//
//  CustomTextField.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI

/// A customizable text field with a title, placeholder, and action button.
/// - Parameters:
///   - title: The title displayed above the text field.
///   - action: The action to perform when the text field button is tapped.
///   - placeholder: The placeholder text displayed when `value` is nil.
///   - value: The current text value displayed in the text field (optional).
/// - Returns: A SwiftUI `View` with a customizable text field interface.
struct CustomTextField: View {
    var title: String
    var action: () -> Void
    var placeholder: String
    var value: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .accessibilityHidden(true)
            Button {
                action()
            } label: {
                HStack {
                    Text(value ?? placeholder)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary.opacity(value != nil ? 1 : 0.8))
                    Image(systemName: "pencil")
                        .foregroundColor(.primary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary.opacity(0.5), lineWidth: 1)
                )
            }
            .accessibilityLabel("\(title)")
            .accessibilityValue(value ?? "Aucune valeur")
            .accessibilityHint("appuyer pour modifier le champ \(title)")
        }
    }
}

#Preview {
    CustomTextField(title: "Taille", action: {}, placeholder: "entrer la taille", value: "1,0 kg")
}
