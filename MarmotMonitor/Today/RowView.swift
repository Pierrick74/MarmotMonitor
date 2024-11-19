//
//  RowView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI

struct RowView: View {
    var activity: ActivityType

    var body: some View {
        HStack {
            ZStack {
                Circle().fill(activity.color)
                    .shadow(radius: 5)
                    .shadow(radius: 5, x: 5, y: 5)

                Image(activity.imageName)
                    .resizable()
                    .padding(10)
                    .background(.clear)
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.title)
                    .foregroundColor(.secondary)
                Text("Il y a 3 Heures")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(.leading, 10)
            Spacer()
            VStack(alignment: .center) {
                Text("30")
                    .font(.body)
                    .bold()
                Text("min")
                    .bold()
            }
            .padding()

        }
        .padding(.horizontal)
        .background(activity.color)
        .cornerRadius(20)
    }
}

#Preview {
    RowView(activity: .bottle(quantity: 5))
}
