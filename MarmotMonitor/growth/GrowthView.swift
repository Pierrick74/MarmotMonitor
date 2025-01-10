//
//  GrowthView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 11/12/2024.
//

import SwiftUI
import Charts

/// A view that displays growth data for a baby in various formats (chart or list).
///
/// Users can toggle between different data visualizations (Weight, Height, Head Circumference, List)
/// using a segmented picker.
struct GrowthView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @StateObject private var manager = GrowthViewManager()

    var body: some View {
        ZStack {
            BackgroundColor()

            VStack(spacing: 0) {
                growthPicker

                if dynamicTypeSize < .accessibility1 {
                    graphView
                }
                listView
                    .padding(.top, 5)
            }
            .padding(.horizontal, 20)
        }
        .onAppear(perform: manager.refreshData)
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let activity = manager.listData[index]
            manager.deleteActivity(activity)
            manager.refreshData()
        }
    }

    // MARK: - Picker

    /// A segmented picker to switch between different views.
    private var growthPicker: some View {
        Picker("", selection: $manager.selectedPosition) {
            Text("Taille").tag(0)
            Text("Poids").tag(1)
            Text("Périmètre").tag(2)
        }
        .pickerStyle(.segmented)
    }

    // MARK: - List
    /// A view that displays individual growth measurements.
    private var listView: some View {
        VStack {
            if manager.listData.isEmpty {
                Spacer()
                Text("Aucune donnée disponible")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(manager.listData, id: \.id) { data in
                        GrowthRow(activity: data)
                    }
                    .onDelete(perform: delete)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - GraphView
    /// A view that displays a line chart
    private var graphView: some View {
        VStack {
            yNameView
            .padding(.top)

            Chart {
                ForEach(manager.dataShow, id: \.key) { (month, height) in
                    LineMark(
                        x: .value("Mois", month),
                        y: .value("Height", height)
                    )
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 1))
                }
            }
            .padding()
            .transition(.asymmetric(
                insertion: .slide.combined(with: .opacity),
                removal: .slide.combined(with: .opacity)
            ))
            .animation(.easeInOut(duration: 0.5), value: manager.selectedPosition)

            xNameView
        }
    }

    private var yNameView: some View {
        HStack(spacing: 0) {
            Text(manager.title)
                .font(.headline)
                .padding(.horizontal, 5)
            Text(manager.unit)
                .font(.body)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var xNameView: some View {
        HStack(spacing: 5) {
            Spacer()
            Text("Âge")
                .font(.headline)
            Text("en Mois")
                .font(.body)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

#Preview {
    GrowthView()
}
