//
//  ItemView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI

struct ItemView: View {
        let item: GridItemData
        let width: CGFloat

        var body: some View {
            VStack(spacing: 0) {
                Image(decorative: item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 4, height: width / 4)
                    .foregroundColor(item.color)
                    .padding(.top, 5)

                Text(item.text)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                    .accessibilityHint("insérer les informations pour \(item.text)")
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .frame(width: width / 3, height: width / 3)
                        .offset(x: 1, y: 1)

                    RoundedRectangle(cornerRadius: 25)
                        .fill(item.color)
                        .frame(width: width / 3, height: width / 3)
                }
            )
        }
    }

#Preview {
    ItemView(item: GridItemData(icon: "Sommeil", text: "Sommeil", color: .sommeil, destination: .sommeil), width: 400)
}
