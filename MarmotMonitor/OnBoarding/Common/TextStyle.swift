//
//  TextStyle.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/11/2024.
//

import SwiftUI
/// View modifier to apply the onboarding text style
/// Parameters:
/// - content: the content to apply the style to
/// - Returns: the content with the onboarding text style
///
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
