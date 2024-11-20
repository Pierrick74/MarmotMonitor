//
//  RowView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI

struct RowView: View {
    var activity: ActivityType
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        ZStack( alignment: .bottom) {
            Rectangle()
                .background(activity.color)
                .cornerRadius(25)
                .frame(height: 80)
                .offset(x: 1, y: 2)

            ZStack(alignment: .top) {
                if dynamicTypeSize < .accessibility3 {
                    HStack {
                        Spacer()
                        Spacer()
                        Image(activity.imageName)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipped()
                        Spacer()
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.title)
                            .font(.title)
                            .foregroundColor(.primary)
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
            }
            .padding(.horizontal, 10)
            .background(activity.color)
            .cornerRadius(25)
        }
        }
}

#Preview {
    RowView(activity: .sleep(duration: 3))
}
