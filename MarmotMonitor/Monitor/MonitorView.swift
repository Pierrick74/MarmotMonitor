//
//  MonitorView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/12/2024.
//

import SwiftUI
/// A view that displays a list of activities with filter options for sleep, diaper, and food categories.
struct MonitorView: View {

    @StateObject var manager = MonitorViewManager()

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()

                VStack {
                    filterButton
                    activityList
                }
            }
            .onAppear {
                manager.loadActivitiesInDateRange()
            }
        }
    }

    private var filterButton: some View {
        HStack {
            Spacer()
            FilterButton(category: .sleep, isSelected: manager.isSleepSelected) {
                withAnimation {manager.toggleFilter(.sleep)}
            }

            FilterButton(category: .diaper, isSelected: manager.isDiaperSelected) {
                withAnimation {manager.toggleFilter(.diaper)}
            }

            FilterButton(category: .food, isSelected: manager.isFoodSelected) {
                withAnimation {manager.toggleFilter(.food)}
            }
            Spacer()
        }
        .padding(.top, 20)
    }

    /// A list of activities grouped by date.
    /// Each row displays the date and a list of activities for that date.
    private var activityList: some View {
        List {
            ForEach(manager.formattedActivityData.keys.sorted(by: >), id: \.self) { date in
                if let activities = manager.formattedActivityData[date] {
                    ActivityRow(data: activities, date: date)
                        .background(
                            NavigationLink("", destination: DetailView(date: date))
                                .opacity(0)
                        )
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
        }
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
    }
}

#Preview {
    MonitorView()
}
