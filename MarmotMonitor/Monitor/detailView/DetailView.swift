//
//  DetailView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//
import SwiftUI

struct DetailView: View {
    @ObservedObject var manager: DetailViewManager
    @Environment(\.dismiss) var dismiss

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
                        DetailRowView(activity: activity)
                    }
                    .onDelete(perform: delete)
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())

                .onAppear {
                    manager.fetchActivityData()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
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
