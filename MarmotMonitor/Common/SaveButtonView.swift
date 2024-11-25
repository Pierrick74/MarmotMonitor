//
//  SaveButtonView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI

struct SaveButtonView: View {
    var onCancel: () -> Void
    var onSave: () -> Void
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                onCancel()
            }, label: {
                Group {
                    if dynamicTypeSize >= .accessibility1 {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    } else {
                        Text("Annuler")
                            .font(.system(.body, design: .default))
                    }
                }
            })
            .buttonStyle(CustomCancelButtonStyle())
            .frame(maxWidth: UIScreen.main.bounds.width / 3)

            Spacer()

            Button(action: {
                onSave()
            }, label: {
                if dynamicTypeSize >= .accessibility1 {
                    Image(systemName: "checkmark")
                } else {
                    Text("Sauvegarder")
                }
            })
            .buttonStyle(CustomSaveButtonStyle())
            .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
        }
        .padding([.bottom, .horizontal], 20)
    }
}

#Preview {
    SaveButtonView(onCancel: {}, onSave: {})
}
