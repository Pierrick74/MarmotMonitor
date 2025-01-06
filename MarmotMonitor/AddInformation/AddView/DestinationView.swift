//
//  DestinationView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI

struct DestinationView: View {
    let destination: ItemDestination

    var body: some View {
        Group {
            switch destination {
            case .sommeil:
                SleepAddView()
            case .couche:
                DiaperAddView()
            case .repas:
                FoodAddView()
            case .croissance:
                GrowthAddView()
            }
        }
    }
}

/// An enumeration defining the possible destinations for activity items.
enum ItemDestination: Hashable {
    case sommeil
    case couche
    case repas
    case croissance
}

#Preview {
    DestinationView(destination: .sommeil)
}
