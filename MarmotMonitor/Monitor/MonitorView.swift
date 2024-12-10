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
                        print("Previous day")
                    }, label: {
                        Image("Sommeil")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(ActivityCategory.sleep.color)
                                    .shadow(color: .primary, radius: 2)
                            )
                            .frame(maxWidth: .infinity)
                    })
                    .disabled(true)

                    Button(action: {
                        print("Previous day")
                    }, label: {
                        Image("Couche")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(ActivityCategory.diaper.color)
                                    .shadow(color: .primary, radius: 2)
                            )
                            .frame(maxWidth: .infinity)
                    })
                    Button(action: {
                        print("Previous day")
                    }, label: {
                        Image("Repas")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(ActivityCategory.food.color)
                                    .shadow(color: .primary, radius: 2)
                            )
                            .frame(maxWidth: .infinity)
                    })
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
    }
}

#Preview {
    MonitorView()
}
