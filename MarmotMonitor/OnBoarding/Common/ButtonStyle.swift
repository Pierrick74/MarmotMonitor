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
            .font(colorScheme == .dark ? .title2.bold() : .title3)
            .foregroundColor(colorScheme == .dark ? .black : .black.opacity(0.8))
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .stroke(Color.white, lineWidth: 1)
                .shadow(color: colorScheme == .dark ? .clear : .primary, radius: 2, x: 2, y: 2))
    }
}

struct OnBoardingBackButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(colorScheme == .light ? .blue.opacity(0.6) : .white.opacity(0.8))
            .background(Circle().fill(.whiteToEgiptienBlue)
                .shadow(color: colorScheme == .light ? .gray : .clear,
                        radius: 1, x: 2, y: 2)
                    .frame(width: 35, height: 35))
            .font(.system(size: 25, weight: .bold, design: .rounded))
            .padding(30)
    }
}
