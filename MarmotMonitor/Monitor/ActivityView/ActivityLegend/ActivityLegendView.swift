//
//  ActivityLegendView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/12/2024.
//

import SwiftUI

struct ActivityLegendView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var manager: ActivityLegendViewManager

    init(data: ActivityLegendData) {
        self.manager = ActivityLegendViewManager(activity: data)
    }

    var body: some View {
        HStack(spacing: 8) {
            if dynamicTypeSize < .accessibility1 {
                Image(decorative: manager.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.primary)

                VStack(alignment: .trailing) {
                    if !manager.recurency.isEmpty {
                        Text(manager.recurency)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    if let total = manager.totalValue {
                        Text(total)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            } else {
                VStack(alignment: .trailing) {
                Text(manager.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                if !manager.recurency.isEmpty {
                    Text(manager.recurency)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                if let total = manager.totalValue {
                    Text(total)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .light ? manager.color : manager.color.mix(with: .black, by: 0.1))
                .stroke(colorScheme == .light ? .clear : Color.primary.opacity(0.5), lineWidth: 1)
                .shadow(radius: 1, x: 1, y: 1)
        )
        .padding(5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(manager.accessibilityDescription)
    }
}

#Preview {
    ActivityLegendView(data: ActivityLegendData(type: .food, recurency: 3, total: 10))
}
