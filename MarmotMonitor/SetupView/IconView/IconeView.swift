//
//  IconeView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/02/2025.
//

import SwiftUI

struct IconView: View {
    let themes = AppIconTheme.allCases
    let appStorage = AppStorageManager.shared

    @State var currentIconName = UIApplication.shared.alternateIconName
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) var dismiss

    var iconSize: CGFloat {
        switch dynamicTypeSize {
        case .accessibility1:
            return 80
        case .accessibility2:
            return 100
        case .accessibility3, .accessibility4, .accessibility5:
            return 120
        default:
            return 60
        }
    }

    var body: some View {
        ZStack {
            BackgroundColor()

            VStack {
                Text("Choisir une Icone")
                    .font(.title.bold())
                listView
            }
            .overlay(alignment: .topLeading) {
                BackButton {
                    dismiss()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - Views
    private var listView: some View {
        List(themes, id: \.self) { theme in
            HStack {
                Image(theme.iconImageName ?? "Icon")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityHidden(true)
                Spacer()
                Button {
                    changeAppIcon(to: theme.iconName)
                } label: {
                    if currentIconName == theme.iconName {
                        Image(systemName: "record.circle")
                            .foregroundColor(.primary)
                            .accessibilityLabel("Icone \(theme.rawValue)")
                            .accessibilityHint("Icone actuellement sélectionnée")
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.primary)
                            .accessibilityLabel("Icone \(theme.rawValue)")
                            .accessibilityHint("Appuyez pour sélectionner cette icône")
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }

    // MARK: - Private methods
    /// Changes the app's icon to the selected theme.
    private func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {return}

        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error setting alternate icon: \(error.localizedDescription)")
            }
        }
        currentIconName = UIApplication.shared.alternateIconName
    }
}

#Preview {
    IconView()
}
