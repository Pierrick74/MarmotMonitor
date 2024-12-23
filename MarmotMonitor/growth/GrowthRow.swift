//
//  GrowthRow.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/12/2024.
//

import SwiftUI

struct GrowthRow: View {
    @Environment(\.colorScheme) var colorScheme

    var date: Date
    var height: Double?
    var weight: Double?
    var headCircumference: Double?
    let unit: String
    let weightUnit: String

    init(activity: BabyActivity) {
        self.date = activity.date
        if case let .growth(data) = activity.activity {
            self.height = data.height
            self.weight = data.weight
            self.headCircumference = data.headCircumference
            self.unit = data.measurementSystem == .metric ? "cm" : "in"
            self.weightUnit = data.measurementSystem == .metric ? "kg" : "lb"
        } else {
            self.height = nil
            self.weight = nil
            self.headCircumference = nil
            self.unit = ""
            self.weightUnit = ""
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(date, style: .date)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.bottom, 5)

            HStack {
                ForEach(measurements, id: \.title) { measurement in
                    if let value = measurement.value {
                        VStack {
                            Text(measurement.title)
                                .font(.body)
                                .foregroundColor(.primary)
                            Text(String(format: "%.1f \(measurement.unit)", value))
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(colorScheme == .light ? .white : .clear)
                .stroke(colorScheme == .light ? .clear : .primary, lineWidth: 1)
                .shadow(color: .primary, radius: 2, x: 0, y: 2)
        )
    }

    // Helper for dynamic display
    private var measurements: [(title: String, value: Double?, unit: String)] {
        return [
            ("Taille", height, unit),
            ("Poids", weight, weightUnit),
            ("Taille tête", headCircumference, unit)
        ]
    }
}

#Preview {
    let baby = BabyActivity(activity:
            .growth(data:
                        GrowthData(
                            weight: 10,
                            height: 12,
                            headCircumference: 12,
                            measurementSystem: .metric)),
                            date: Date())
    GrowthRow(activity: baby)
}
