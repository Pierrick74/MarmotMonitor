//
//  IconView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/12/2024.
//

import SwiftUI

struct IconView: View {
    @Environment(\.colorScheme) var colorScheme
    let themes = AppIconTheme.allCases

    var body: some View {
        VStack {
            Text("Modifier la couleur de l'icone")
                .font(.headline)
                .padding(.bottom, 10)

            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(themes, id: \.self) { theme in
                        Button {
                            changeAppIcon(to: theme.iconName)
                        } label: {
                            Rectangle()
                                .fill(theme.color)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(colorScheme == .light ? .white : .clear)
                .stroke(colorScheme == .light ? .clear : .primary, lineWidth: 1)
                .shadow(color: .primary, radius: 2, x: 0, y: 2)
        )
    }

    private func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {return}

        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error setting alternate icon: \(error.localizedDescription)")
            }
        }
    }
}
#Preview {
    IconView()
}
