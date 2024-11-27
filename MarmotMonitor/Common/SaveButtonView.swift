//
//  SaveButtonView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI

struct SaveButtonView: View {
    var onSave: () -> Void
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        HStack(spacing: 10) {
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
    SaveButtonView(onSave: {})
}
