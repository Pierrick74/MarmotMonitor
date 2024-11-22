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

    init(activity: BabyActivity) {
        self.manager = RowManager(babyActivity: activity)
    }

    var body: some View {
        ZStack( alignment: .bottom) {
            Rectangle()
                .background(manager.color)
                .cornerRadius(25)
                .frame(height: 80)
                .offset(x: 1, y: 2)

            ZStack(alignment: .center) {
                if dynamicTypeSize < .accessibility1 {
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
                if dynamicTypeSize < .accessibility1 {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(manager.title)
                                .font(.title)
                                .foregroundColor(.primary)
                            Text(manager.lastActivity)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 10)
                        Spacer()
                        VStack(alignment: .center) {
                            Text(manager.information)
                                .bold()
                        }
                        .padding()
                    }
                } else {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(manager.title)
                                .font(.title)
                                .foregroundColor(.primary)
                            Text(manager.lastActivity)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Text(manager.information.replacingOccurrences(of: "\n", with: " "))
                        }
                        Spacer()
                    }
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
    RowView(activity: BabyActivity(activity: .growth(data: GrowthData(weight: 19, height: 70, headCircumference: nil)), date: .now))
}
