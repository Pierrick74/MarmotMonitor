//
//  DetailRowView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI

struct DetailRowView: View {
        let activity: ActivityDetail

        var body: some View {
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
}

#Preview {
    DetailRowView(activity: ActivityDetail(from: BabyActivity(activity: .sleep(duration: 152), date: .now)))
}
