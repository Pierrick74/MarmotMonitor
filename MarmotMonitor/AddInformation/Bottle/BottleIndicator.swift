//
//  BottleIndicator.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 30/11/2024.
//

import SwiftUI

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
                .foregroundColor(.black)

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
    BottleIndicator(height: 20, texte: "20 ml")
}
