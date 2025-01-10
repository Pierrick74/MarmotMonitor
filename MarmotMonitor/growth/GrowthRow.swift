//
//  GrowthRow.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/12/2024.
//

import SwiftUI

/// A view displaying growth-related data for a baby activity.
///
/// The view adapts dynamically to the user's text size preference and color scheme.
/// It shows information like height, weight, and head circumference.
///
/// - Parameter activity: A `BabyActivity` instance containing growth data.
struct GrowthRow: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    private let date: Date
    private let measurements: [Measurement]

    /// Initializes the `GrowthRow` with a `BabyActivity`.
    init(activity: BabyActivity) {
        self.date = activity.date
        if case let .growth(data) = activity.activity {
            let lengthUnit = data.measurementSystem == .metric ? "cm" : "in"
            let weightUnit = data.measurementSystem == .metric ? "kg" : "lb"

            self.measurements = [
                Measurement(title: "Taille", value: data.height, unit: lengthUnit),
                Measurement(title: "Poids", value: data.weight, unit: weightUnit),
                Measurement(title: "Taille tête", value: data.headCircumference, unit: lengthUnit)
            ]
        } else {
            self.measurements = []
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(date, style: .date)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.bottom, 5)
                .accessibilityLabel("Date de la mesure : \(date, style: .date)")

            if dynamicTypeSize < .accessibility1 {
                HStack {
                    ForEach(measurements, id: \.title) { measurement in
                        MeasurementView(measurement: measurement)
                    }
                }
            } else {
                VStack(spacing: 10) {
                    ForEach(measurements, id: \.title) { measurement in
                        MeasurementView(measurement: measurement)
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
}

// MARK: - Measurement View
/// A reusable view for displaying individual measurements.
struct MeasurementView: View {
    let measurement: Measurement

    var body: some View {
        VStack {
            Text(measurement.title)
                .font(.body)
                .foregroundColor(.secondary)
                .accessibilityHidden(true)

            if let value = measurement.value {
                Text("\(value, specifier: "%.1f") \(measurement.unit)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibilityLabel("\(measurement.title) : \(value, specifier: "%.1f") \(measurement.unit)")
            } else {
                Text("N/A")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel("\(measurement.title) : non renseigné")
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Measurement Model

/// A model representing a single measurement.
struct Measurement: Identifiable {
    let id = UUID()
    let title: String
    let value: Double?
    let unit: String
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
