//
//  BackButton.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/11/2024.
//

import SwiftUI

struct BackButton: View {
        let action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }, label: {
                Image(systemName: "chevron.backward")
                    .font(.body)
                    .dynamicTypeSize(.large)
                    .padding(8)
                    .tint(.primary)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Circle())
                    .padding(.horizontal, 10)
                    .shadow(radius: 3, x: 3, y: 3)
            })
        }
}

#Preview {
    BackButton(action: {})
}
