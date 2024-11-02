//
//  OnBoardingBackground.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/11/2024.
//

import SwiftUI

struct OnBoardingBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(colorScheme == .dark ? Color.secondary.opacity(0.2) : Color.white)
                    .stroke(Color.white, lineWidth: 1)
                    .shadow(color: colorScheme == .dark ? .clear : .primary,
                            radius: 2, x: 2, y: 2)
            )
            .padding(.vertical, 30)
    }
}

// 2. Extension View pour faciliter l'utilisation
extension View {
    func onBoardingBackground() -> some View {
        modifier(OnBoardingBackgroundModifier())
    }
}
