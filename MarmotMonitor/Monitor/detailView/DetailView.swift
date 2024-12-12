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
        Text(manager.date, style: .date)
            .font(.headline)
            .padding(.bottom, 8)

        List(manager.formattedActivityData) { activity in
            HStack {
                // Image
                Image(decorative: activity.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)

                // Détails de l'activité
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.startHour)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text(activity.type)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Valeur de l'activité
                Text(activity.value)
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            manager.fetchActivityData()
        }
        .padding()
    }
}

#Preview {
    DetailView(date: .now)
}
