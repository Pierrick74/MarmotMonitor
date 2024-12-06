//
//  SwiftUIView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/12/2024.
//

import SwiftUI

struct ActivityView: View {
    let date: Date
    let hourlyColors: [Color]
    let activityLegende: [ActivityLegendData]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(date, style: .date)
                    .font(.headline)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    // Action d'édition ici
                }, label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.primary)
                })
            }
            .padding(.horizontal)

            VStack {
                HStack(spacing: 3) {
                    ForEach(0..<48) { hour in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(hourlyColors[hour])
                            .frame(height: 50)
                            .shadow(radius: 1, x: 1, y: 1)
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

            HStack {
                ForEach(activityLegende, id: \.type) { legend in
//                    ActivityLegendView(type: legend.type,
//                                   time: "\(legend.recurency) fois",
//                                   frequency: legend.total != nil ? "\(legend.total!) fois" : "",
//                                   color: .blue)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(radius: 5, x: 5, y: 5)
        )
    }
}



#Preview {
    ActivityView(
        date: Date(),
        hourlyColors: Array(repeating: .green, count: 48),
        activityLegende: [
            ActivityLegendData(type: .sleep, recurency: 1, total: 3),
            ActivityLegendData(type: .diaper, recurency: 1, total: nil),
            ActivityLegendData(type: .food, recurency: 1, total: nil)
        ]
    )
}
