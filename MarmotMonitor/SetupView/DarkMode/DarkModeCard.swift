//
//  DarkModeCard.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/12/2024.
//

import SwiftUI

/// A view that allows users to toggle between light mode, dark mode, or system appearance.
/// - Synchronizes user preferences with `AppStorageManager`.
struct DarkModeCard: View {
    /// Represents the appearance modes available for selection.
    enum Mode {
            case light, dark
    }

    // MARK: - Dependencies
    var storageManager = AppStorageManager.shared

    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme

    @State private var mode: Mode = .light
    @State private var isSystemModeActivate = false

    var body: some View {
        VStack(spacing: 0) {
            apparenceSelection
            systemSelection
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

    // MARK: - Private Methods
    /// Synchronizes the view's appearance with the stored user preference.
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

    private var apparenceSelection: some View {
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
    }

    private var systemSelection: some View {
        Toggle(isOn: $isSystemModeActivate) {
            Text("Synchroniser avec l'apparence du système")
                .font(.headline)
        }
        .toggleStyle(SwitchToggleStyle(tint: .secondary))
        .accessibilityLabel("Synchronisation avec l'apparence système")
        .accessibilityHint("L'apparence de l'application sera automatiquement synchronisée avec l'apparence du système")
        .accessibilityValue(isSystemModeActivate ? "Activé" : "Désactivé")
        .padding()
    }
}

#Preview {
    DarkModeCard()
}
