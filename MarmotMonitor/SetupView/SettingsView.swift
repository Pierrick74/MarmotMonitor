//
//  SettingsView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/02/2025.
//

import SwiftUI

struct SettingsViewType {
    let iconeName: String
    let title: String
    var description: String
    let destination: AnyView
}

struct SettingsView: View {
    var settings: [SettingsViewType] = [
          SettingsViewType(iconeName: "info.circle", title: "Informations", description: "", destination: AnyView(InformationView())),
          SettingsViewType(iconeName: "moon", title: "Apparence", description: "", destination: AnyView(DarkModeView())),
          SettingsViewType(iconeName: "paintbrush", title: "Icone", description: "", destination: AnyView(IconView())),
          SettingsViewType(iconeName: "ruler", title: "Unités", description: "", destination: AnyView(UnitView())),
          SettingsViewType(iconeName: "info.circle", title: "À propos", description: "", destination: AnyView(EmptyView()))
      ]

    var body: some View {
        ZStack {
            BackgroundColor()
            VStack {
                Text("Réglages")
                    .font(.title.bold())
                List {
                    ForEach(settings, id: \.title) { setting in
                        NavigationLink(destination: setting.destination) {
                            HStack {
                                Image(systemName: setting.iconeName)
                                    .foregroundColor(.primary)
                                Text(setting.title)
                                    .font(.body.bold())
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(setting.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .foregroundColor(.primary)
                    }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .scrollContentBackground(.hidden)
                .scrollBounceBehavior(.basedOnSize)
                .ignoresSafeArea(edges: .horizontal)
            }
            .ignoresSafeArea(edges: .horizontal)
            .padding(5)
        }
    }
}

#Preview {
    SettingsView()
}
