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
                SleepView()
            case .couche:
                SleepView()
            case .biberon:
                SleepView()
            case .repas:
                SleepView()
            case .allaitement:
                SleepView()
            case .croissance:
                SleepView()
            }
        }
    }
}

#Preview {
    DestinationView(destination: .sommeil)
}
