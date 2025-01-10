//
//  BackgroundColor.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//
import SwiftUI

/// A view that provides a background gradient based on user settings.
///
/// The gradient adapts to the gender setting stored in `AppStorageManager` and adjusts
/// dynamically to the system's color scheme.
///
/// - Parameters:
///   - manager: Observed object to access user preferences.
///   - colorScheme: The system's color scheme.
/// - Returns:
///   A `LinearGradient` view covering the entire screen.
struct BackgroundColor: View {
    @ObservedObject private var manager = AppStorageManager.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let gradientColors = determineGradientColors()

        return LinearGradient(
            gradient: Gradient(colors: gradientColors),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }

    /// Determines the colors to use for the gradient based on user preferences.
    ///
    /// The gradient adapts to the gender setting, using predefined colors for boys or girls.
    /// - Returns: An array of `Color` representing the gradient colors.
    private func determineGradientColors() -> [Color] {
        if manager.gender == GenderType.boy {
            return [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]
        } else {
            return [.pinkToEgiptienBlue, .whiteToEgiptienBlue]
        }
    }
}
