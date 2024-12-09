//
//  ActivityLegendView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/12/2024.
//

import SwiftUI

struct ActivityLegendView: View {
    @Environment(\.colorScheme) var colorScheme

    var manager: ActivityLegendViewManager

    init(data: ActivityLegendData) {
        self.manager = ActivityLegendViewManager(activity: data)
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(manager.name)
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
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .light ? manager.color : Color.primary.opacity(0.1))
                .stroke(colorScheme == .light ? .clear : Color.primary.opacity(0.5), lineWidth: 1)
                .shadow(radius: 1, x: 1, y: 1)
        )
    }
}

#Preview {
    ActivityLegendView(data: ActivityLegendData(type: .food, recurency: 3, total: 10))
}
