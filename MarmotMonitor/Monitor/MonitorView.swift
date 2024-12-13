//
//  MonitorView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/12/2024.
//

import SwiftUI

struct MonitorView: View {

    @StateObject var manager = MonitorViewManager()

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()

                VStack {
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
            .onAppear {
                manager.loadActivitiesInDateRange()
            }
        }
    }
}

#Preview {
    MonitorView()
}
