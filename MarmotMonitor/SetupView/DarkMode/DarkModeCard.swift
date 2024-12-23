//
//  DarkModeCard.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/12/2024.
//

import SwiftUI

/// A view that allows the user to select the app's appearance mode.
/// The user can choose between light mode, dark mode or system mode.
/// When system mode is selected, the app's appearance is automatically set to the system's appearance.
/// When light or dark mode is selected, the app's appearance is set to the selected mode.

struct DarkModeCard: View {
    enum Mode {
            case light, dark
    }

    var storageManager = AppStorageManager.shared
    @Environment(\.colorScheme) var colorScheme

    @State private var mode: Mode = .light
    @State private var isSystemModeActivate = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 40) {
                Spacer()
                ModeButton(
                    imageName: "lightMode",
                    isSelected: mode == .light,
                    isDisabled: isSystemModeActivate,
                    action: { mode = .light }
                )
                Spacer()

                ModeButton(
                    imageName: "darkMode",
                    isSelected: mode == .dark,
                    isDisabled: isSystemModeActivate,
                    action: { mode = .dark }
                )
                Spacer()
            }
            .padding(.top, 20)

            Toggle(isOn: $isSystemModeActivate) {
                Text("Apparence Systeme")
                    .font(.headline)
            }
            .toggleStyle(SwitchToggleStyle(tint: .secondary))
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(colorScheme == .light ? .white : .clear)
                .stroke(colorScheme == .light ? .clear : .primary, lineWidth: 1)
                .shadow(color: .primary, radius: 2, x: 0, y: 2)
        )
        .onAppear {
            syncWithStoredAppearance()
                }
        .onChange(of: mode) {
            if isSystemModeActivate == false {
                storageManager.appearance = mode == .light ? .light : .dark
            }
        }
        .onChange(of: isSystemModeActivate) {
            if isSystemModeActivate == true {
                storageManager.appearance = .system
            } else {
                storageManager.appearance = mode == .light ? .light : .dark
            }
        }
    }

    private func syncWithStoredAppearance() {
        switch storageManager.appearance {
        case .system:
            isSystemModeActivate = true
            mode = .light
        case .light:
            isSystemModeActivate = false
            mode = .light
        case .dark:
            isSystemModeActivate = false
            mode = .dark
        }
    }
}

#Preview {
    DarkModeCard()
}
