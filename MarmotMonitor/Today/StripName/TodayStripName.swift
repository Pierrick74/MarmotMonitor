//
//  TodayStripName.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/11/2024.
//

import SwiftUI

struct TodayStripName: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var manager = TodayStripNameManager()

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(manager.welcomeMessage).font(.title).foregroundColor(.primary)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)

                Text(manager.babyInfo).foregroundStyle(.primary).font(.body)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            Spacer()
            VStack(spacing: 0) {
                Text(Date.now, format: .dateTime.month())
                    .font(.body.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .background(Rectangle().fill(.red.mix(with: .black, by: 0.1)))
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)

                Text(Date.now, format: .dateTime.day())
                    .font(.title.bold())
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
            }
            .background(Rectangle().fill(.white))
            .cornerRadius(7)
            .padding(7)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("nous sommes le \(Date.now, format: .dateTime.day()) \(Date.now, format: .dateTime.month())")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TodayStripName(manager: TodayStripNameManager(storageManager: MockAppStorageManagerForStripName()))
}
