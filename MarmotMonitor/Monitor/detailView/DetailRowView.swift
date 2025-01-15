//
//  DetailRowView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI
/// A view that displays the details of an activity in a visually appealing row format.
/// Parameters:
/// - activity: The activity to display.

struct DetailRowView: View {
    let activity: ActivityDetail

    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        Group {
            if dynamicTypeSize < .accessibility1 {
                compactLayout
            } else {
                expandedLayout
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(activity.color.opacity(0.8))
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
        )
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    /// A view for normal size
    private var compactLayout: some View {
        HStack {
            Image(decorative: activity.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(8)

            activityDétail
            Spacer()
            activityValue
        }
    }

    /// A view for large size
    private var expandedLayout: some View {
        VStack(alignment: .leading, spacing: 4) {
            activityDétail
            activityValue
        }
    }

    /// A view that displays the start hour and type of the activity
    private var activityDétail: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(activity.startHour)
                .font(.subheadline)
                .foregroundColor(.primary)
            Text(activity.type)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    /// A view that displays the value of the activity
    private var activityValue: some View {
        Text(activity.value)
            .font(.headline)
            .foregroundColor(.primary)
    }
}

#Preview {
    DetailRowView(activity: ActivityDetail(from: BabyActivity(activity: .sleep(duration: 152), date: .now)))
}
