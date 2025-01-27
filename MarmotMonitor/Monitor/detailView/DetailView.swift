//
//  DetailView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//
import SwiftUI

/// A detailed view displaying activities for a specific date.
/// Includes a list of activities and supports deletion.
struct DetailView: View {

    @StateObject private var manager: DetailViewManager
    @Environment(\.dismiss) var dismiss

    init(date: Date) {
        _manager = StateObject(wrappedValue: DetailViewManager(date: date))
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
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
        }
        .onAppear {
            manager.fetchActivityData()
        }
    }

    /// Deletes activities at the specified offsets.
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
