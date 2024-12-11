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
        ZStack {
            BackgroundColor()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            manager.toggleFilter(.sleep)
                        }
                    }, label: {
                        Image("Sommeil")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(manager.isSleepSelected ? ActivityCategory.sleep.color : .gray)
                                    .shadow(color: .primary, radius: 2)
                            )
                            .frame(maxWidth: .infinity)
                    })
                    .accessibilityLabel("Filtre sommeil \(manager.isSleepSelected ? "activé" : "désactivé")")

                    Button(action: {
                        withAnimation {
                            manager.toggleFilter(.diaper)
                        }
                    }, label: {
                        Image("Couche")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(manager.isDiaperSelected ? ActivityCategory.diaper.color : .gray)
                                    .shadow(color: .primary, radius: 2)
                            )
                            .frame(maxWidth: .infinity)
                    })
                    .accessibilityLabel("Filtre couche \(manager.isDiaperSelected ? "activé" : "désactivé")")

                    Button(action: {
                        withAnimation {
                            manager.toggleFilter(.food)
                        }
                    }, label: {
                        Image("Repas")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(manager.isFoodSelected ? ActivityCategory.food.color : .gray)
                                    .shadow(color: .primary, radius: 2)
                            )
                            .frame(maxWidth: .infinity)
                    })
                    .accessibilityLabel("Filtre repas \(manager.isFoodSelected ? "activé" : "désactivé")")

                    Spacer()
                }
                .padding(.top, 20)

                List {
                    ForEach(manager.formattedActivityData.keys.sorted(by: >), id: \.self) { date in
                        if let activities = manager.formattedActivityData[date] {
                            ActivityRow(data: activities, date: date)
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
            manager.createActivityDataInRange()
        }
    }
}

#Preview {
    MonitorView()
}
