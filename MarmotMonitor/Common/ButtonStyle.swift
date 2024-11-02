//
//  ButtonStyle.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/11/2024.
//

import SwiftUI

struct OnBoardingButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .foregroundColor(colorScheme == .dark ? .white : .black.opacity(0.8))
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 30)
                .fill(colorScheme == .dark ? Color.secondary.opacity(0.2) : Color.white)
                .stroke(Color.white, lineWidth: 1)
                .shadow(color: colorScheme == .dark ? .gray : .primary, radius: 2, x: 2, y: 2))
    }
}
