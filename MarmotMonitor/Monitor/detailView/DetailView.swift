//
//  DetailView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//
import SwiftUI

struct DetailView: View {
    @ObservedObject var manager: DetailViewManager

    init(date: Date) {
        self.manager = DetailViewManager(date: date)
    }

    var body: some View {
        ZStack {
            BackgroundColor()

            VStack {
                    Text(manager.date, style: .date)
                        .font(.headline)
                        .padding(.bottom, 8)

                List {
                    ForEach(manager.formattedActivityData) { activity in
                        HStack {
                            Image(decorative: activity.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(activity.startHour)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Text(activity.type)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()

                            Text(activity.value)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(activity.color.opacity(0.8))
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity)
                    }
                    .onDelete(perform: delete)
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())

                .onAppear {
                    manager.fetchActivityData()
                }
                .padding()
            }
        }
    }

    func delete(at offsets: IndexSet) {
        let activitiesToDelete = offsets.map { manager.formattedActivityData[$0] }

        for activity in activitiesToDelete {
            manager.deleteActivity(activity)
        }

        manager.fetchActivityData()
    }

}

#Preview {
    DetailView(date: .now)
}
