//
//  MonitorView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/12/2024.
//

import SwiftUI

struct MonitorView: View {
    var data: [Date: [ActivityRange]] = [
            Calendar.current.startOfDay(for: Date()): [
                ActivityRange(startHour: 10, endHour: 15, type: .sleep, value: 4, unit: nil),
                ActivityRange(startHour: 24, endHour: 25, type: .diaper, value: nil, unit: nil),
                ActivityRange(startHour: 29, endHour: 30, type: .food, value: 5, unit: nil)
            ],
            Calendar.current.date(byAdding: .day, value: -1, to: Date())!: [
                ActivityRange(startHour: 10, endHour: 15, type: .sleep, value: 4, unit: nil),
                ActivityRange(startHour: 24, endHour: 25, type: .diaper, value: nil, unit: nil)
            ]
        ]

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
                    ForEach(data.keys.sorted(by: >), id: \.self) { date in
                        if let activities = data[date] {
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
