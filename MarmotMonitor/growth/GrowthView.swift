//
//  GrowthView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 11/12/2024.
//

import SwiftUI
import Charts
/// View to display the growth of the baby
/// The user can choose between the weight, the height and the perimeter
/// The data is displayed in a chart
/// The user can see the data for each month

struct GrowthView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var manager = GrowthViewManager()

    var body: some View {
        ZStack {
            BackgroundColor()

            VStack(spacing: 0) {
                Picker("", selection: $manager.selectedPosition) {
                    Text("Poids")
                        .tag(0)
                    Text("Taille")
                        .tag(1)
                    Text("Périmètre")
                        .tag(2)
                    Text("Liste")
                        .tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)
                .padding(.top, 10)

                if manager.selectedPosition < 3 {
                    HStack(spacing: 0) {
                        Text(manager.title)
                            .font(.headline)
                            .padding(.horizontal, 5)
                        Text(manager.unit)
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.top)

                    Chart {
                        ForEach(Array(manager.dataShow).sorted(by: { $0.key < $1.key }), id: \.key) { (month, height) in
                            LineMark(
                                x: .value("Mois", month),
                                y: .value("Height", height)
                            )
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .interpolationMethod(.catmullRom)
                            .lineStyle(.init(lineWidth: 1))
                        }
                    }
                    .chartXAxis {
                        AxisMarks(preset: .extended, values: .stride(by: 5))
                    }
                    .padding()
                    .transition(.asymmetric(
                        insertion: .slide.combined(with: .opacity),
                        removal: .slide.combined(with: .opacity)
                    ))
                    .animation(.easeInOut(duration: 0.5), value: manager.selectedPosition)

                    HStack(spacing: 5) {
                        Spacer()
                        Text("Âge")
                            .font(.headline)
                        Text("en Mois")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.bottom, 40)
                } else {
                    List {
                        ForEach(manager.listData, id: \.id) { data in
                            GrowthRow(activity: data)
                        }
                        .onDelete(perform: delete)
                        .listRowBackground(Color.clear)
                    }
                    .padding(.top, 20)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let activity = manager.listData[index]
            manager.deleteActivity(activity)
        }
    }
}

#Preview {
    GrowthView()
}
