//
//  DarkModeCard.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/12/2024.
//

import SwiftUI

/// A view that allows users to toggle between light mode, dark mode, or system appearance.
/// - Synchronizes user preferences with `AppStorageManager`.
struct DarkModeView: View {
    /// Represents the appearance modes available for selection.
    enum Mode {
            case light, dark
    }

    // MARK: - Dependencies
    var storageManager = AppStorageManager.shared

    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @State private var mode: Mode = .light
    @State private var isSystemModeActivate = false

    var body: some View {
        ZStack {
            BackgroundColor()
            VStack(spacing: 0) {
                Text("Apparence")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20)
                apparenceSelection
                    .padding(.bottom, 20)
                systemSelection
                Spacer()
            }
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
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
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
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}

#Preview {
    DarkModeView()
}
