//
//  AccessibilityItemView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/11/2024.
//

import SwiftUI

struct AccessibilityItemView: View {
    let item: GridItemData

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .fill(item.color)
            HStack {
                Image(decorative: item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.top, 5)
                Text(item.text)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    AccessibilityItemView(item: GridItemData(icon: "Sommeil", text: "Sommeil", color: .sommeil, destination: .sommeil))
}
