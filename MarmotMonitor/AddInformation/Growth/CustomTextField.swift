//
//  CustomTextField.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    var action: () -> Void
    var placeholder: String
    var value: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            Button {
                action()
            } label: {
                HStack {
                    Text(value != nil ? value!: placeholder)
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
        }
    }
}

#Preview {
    CustomTextField(title: "Taille", action: {}, placeholder: "entrer la taille", value: "1,0 kg")
}
