//
//  TextStyle.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/11/2024.
//

import SwiftUI

struct OnBoardingTextStyleModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .font(colorScheme == .dark ? .body.bold() : .body)
            .padding(.bottom, 10)
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .shadow(color: colorScheme == .dark ? .black : .clear,
                    radius: 5)
    }
}

extension View {
    func onBoardingTextStyle() -> some View {
        modifier(OnBoardingTextStyleModifier())
    }
}
