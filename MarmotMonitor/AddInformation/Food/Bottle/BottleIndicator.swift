//
//  BottleIndicator.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 30/11/2024.
//

import SwiftUI
/// View that represents the bottle indicator level
/// Parameters:
/// - height: the height of the bottle indicator
/// - texte: the text to display below the bottle indicator

struct BottleIndicator: View {

    var height: Double
    var texte: String

    var body: some View {
        VStack {
            Spacer()

            Text(texte)
                .font(.title)
                .fontWeight(.bold)

            Rectangle()
                .frame(width: 100, height: 1)
                .foregroundColor(.primary)

            Rectangle()
                .frame(height: height)
                .foregroundColor(.clear)
            Rectangle()
                .frame(height: 40)
                .foregroundColor(.clear)
        }
        .frame(width: 100)
    }
}

#Preview {
    BottleIndicator(height: 20, texte: "320 ml")
}
