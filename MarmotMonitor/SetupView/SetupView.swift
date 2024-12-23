//
//  SetupView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI

struct SetupView: View {
    @AppStorage("appearance") private var appearance: Appearance = .system
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                ScrollView {
                    VStack(spacing: 0) {

                        NavigationLink(destination: InformationView()) {
                            InformationRow()
                        }

                        DarkModeCard()
                            .padding()

                        IconView()
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    SetupView()
}
