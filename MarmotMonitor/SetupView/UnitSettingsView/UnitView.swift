//
//  UnitView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/02/2025.
//

import SwiftUI

struct UnitType {
    let name: String
    var description: String
    var isMetric: Bool
}

struct UnitView: View {
    let dataManager = AppStorageManager.shared

    var units: [UnitType] = [
        UnitType(name: "Metric", description: "ml, cm, kg", isMetric: true),
        UnitType(name: "Imperial", description: "oz, in, lb", isMetric: false)
    ]

    @State var currentUnit: Bool = AppStorageManager.shared.isMetricUnit
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            BackgroundColor()

            VStack {
                Text("Unité de mesure")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                unitList
                Spacer()
            }
        }
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Private View
    private var unitList: some View {
        VStack {
            List(units, id: \.name) { unit in
                HStack {
                    Text(unit.name)
                        .font(.title2)
                        .accessibilityHidden(true)
                        .padding(10)
                    Text(unit.description)
                        .font(.body)
                        .accessibilityHidden(true)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button {
                        dataManager.isMetricUnit = unit.isMetric
                        currentUnit = unit.isMetric
                    } label: {
                        if currentUnit == unit.isMetric {
                            Image(systemName: "record.circle")
                                .foregroundColor(.primary)
                                .accessibilityLabel("Unité")
                                .accessibilityHint("Icone actuellement sélectionnée")
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.primary)
                                .accessibilityLabel("Unité")
                                .accessibilityHint("Appuyez pour sélectionner cette icône")
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    UnitView()
}
