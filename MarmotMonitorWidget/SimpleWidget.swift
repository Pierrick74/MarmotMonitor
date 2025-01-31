//
//  SimpleWidget.swift
//  MarmotMonitorWidgetExtension
//
//  Created by pierrick viret on 29/01/2025.
//

import SwiftUI

struct SimpleWidget: View {
    let date: Date?
    let type: ActivityCategory

    var body: some View {
        VStack {
            Text(type.rawValue)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.bottom, 2)
                .multilineTextAlignment(.center)
                .shadow(color: Color.black.opacity(0.7), radius: 4, x: 0, y: 2)
            VStack {
                if let stringDate = date?.detailedTimeBetweenDatesAndNow() {
                    Text(stringDate)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                } else {
                    Text("Aucune\ndonnée")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.7)) // Ajout d’une opacité pour un effet visuel plus doux
                }
            }
            .multilineTextAlignment(.center)
            .shadow(color: Color.black.opacity(0.7), radius: 4, x: 1, y: 1)

        }
        .foregroundColor(.white)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(type.color)

                Image(type.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .blur(radius: 1.5)
                    .opacity(0.3)
            }
        )
        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
    }
}
