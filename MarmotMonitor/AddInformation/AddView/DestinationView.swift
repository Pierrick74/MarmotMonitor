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
                BottleAddView()
            case .croissance:
                SleepAddView()
            }
        }
    }
}

#Preview {
    DestinationView(destination: .sommeil)
}
