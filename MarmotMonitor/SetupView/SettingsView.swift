//
//  SettingsView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/02/2025.
//

import SwiftUI

enum SettingsOption: CaseIterable, Identifiable {
    case information
    case darkMode
    case icon
    case units
    case about

    var id: String { title }

    var iconName: String {
        switch self {
        case .information: return "info.circle"
        case .darkMode: return "moon"
        case .icon: return "paintbrush"
        case .units: return "ruler"
        case .about: return "info.circle"
        }
    }

    var title: String {
        switch self {
        case .information: return "Informations"
        case .darkMode: return "Apparence"
        case .icon: return "Icône"
        case .units: return "Unités"
        case .about: return "À propos"
        }
    }
}

struct SettingsView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()
                VStack {
                    Text("Réglages")
                        .font(.title.bold())
                    List {
                        ForEach(SettingsOption.allCases, id: \.title) { setting in
                            NavigationLink(value: setting) {
                                HStack {
                                    Image(systemName: setting.iconName)
                                        .foregroundColor(.primary)
                                    Text(setting.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.clear)
                            .foregroundColor(.primary)
                            .padding(.vertical, 7)
                        }
                    }
                    .navigationDestination(for: SettingsOption.self, destination: { destination in
                        switch destination {
                        case .information: InformationView()
                        case .darkMode: DarkModeView()
                        case .icon: IconView()
                        case .units: UnitView()
                        case .about: AboutView()
                        }
                    })
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
}

#Preview {
    SettingsView()
}
