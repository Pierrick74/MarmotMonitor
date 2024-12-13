//
//  SetupView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI

struct SetupView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                ZStack {
                    InformationRow()
                    NavigationLink(destination: InformationView()) {
                        Color.clear // Zone cliquable invisible
                    }
                }
            }
        }
    }
}

#Preview {
    SetupView()
}
