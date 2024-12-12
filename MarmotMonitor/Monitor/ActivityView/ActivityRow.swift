//
//  ActivityRow.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/12/2024.
//

import SwiftUI

struct ActivityRow: View {
    let date: Date
    var manager: ActivityRowManager

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.colorScheme) var colorScheme

    init(data: [ActivityRange], date: Date) {
        self.manager = ActivityRowManager(data: data)
        self.date = date
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(date, style: .date)
                    .font(.headline)
                    .padding(.horizontal)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    // Action d'édition ici
                }, label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.primary)
                })
                .accessibilityHidden(true)
            }
            .padding(.horizontal)

            if dynamicTypeSize < .accessibility1 {
                VStack {
                    HStack(spacing: 4) {
                        ForEach(0..<48) { hour in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(manager.color(for: hour))
                                .stroke(colorScheme == .dark ? Color.white : .black, lineWidth: 0.3)
                                .frame(height: 50)
                        }
                    }

                    HStack {
                        ForEach(["2h", "6h", "10h", "14h", "18h", "22h"], id: \.self) { hour in
                            Text(hour)
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .accessibilityHidden(true)
            }

            if dynamicTypeSize < .accessibility1 {
                HStack {
                    ForEach(manager.generateLegend(), id: \.type) { legend in
                        ActivityLegendView(data: legend)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            } else {
                VStack {
                    ForEach(manager.generateLegend(), id: \.type) { legend in
                        ActivityLegendView(data: legend)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(colorScheme == .dark ? Color.secondary.opacity(0.2) : Color.gray.mix(with: .white, by: 0.9))
                .stroke(colorScheme == .dark ? Color.white : .clear, lineWidth: 1)
                .shadow(radius: 5, x: 5, y: 5)
        )
    }
}

#Preview {
    ActivityRow(
        data: [
            ActivityRange(startHour: 28, endHour: 29, type: .food, value: 200, unit: .metric),
            ActivityRange(startHour: 17, endHour: 18, type: .food, value: 200, unit: .metric),
            ActivityRange(startHour: 27, endHour: 30, type: .diaper, value: 200, unit: .metric),
            ActivityRange(startHour: 0, endHour: 15, type: .sleep, value: 15, unit: .metric),
            ActivityRange(startHour: 24, endHour: 38, type: .sleep, value: 15, unit: .metric)
        ], date: Date()
    )
}
