//
//  RowView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI

struct RowView: View {
    var manager: RowManager
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    init(activity: Activity) {
        self.manager = RowManager(activity: activity)
    }

    var body: some View {
        ZStack( alignment: .bottom) {
            Rectangle()
                .background(manager.color)
                .cornerRadius(25)
                .frame(height: 80)
                .offset(x: 1, y: 2)

            ZStack(alignment: .top) {
                if dynamicTypeSize < .accessibility3 {
                    HStack {
                        Spacer()
                        Spacer()
                        Image(manager.imageName)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipped()
                        Spacer()
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(manager.title)
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
            .background(manager.color)
            .cornerRadius(25)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(manager.accessibilityDescription)
    }
}

#Preview {
    RowView(activity: .sleep(duration: 3))
}
