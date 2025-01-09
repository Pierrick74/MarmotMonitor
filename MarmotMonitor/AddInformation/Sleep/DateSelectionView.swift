//
//  DateSelectionView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//
import SwiftUI

/// A view for selecting a date using a button.
/// - Displays the currently selected date or a placeholder if no date is set.
/// - Parameters:
///   - title: The title displayed above the button.
///   - date: The currently selected date (optional).
///   - buttonAction: The action to perform when the button is tapped.
/// - Returns: A SwiftUI `View` for date selection.
struct DateSelectionView: View {
    var title: String
    var date: Date?
    var buttonAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .accessibilityHidden(true)

            Button(action: buttonAction) {
                HStack {
                    Text(date != nil ? date!.formatted(date: .abbreviated, time: .shortened) : "Appuyer pour sélectionner")
                        .foregroundColor(.primary.opacity(date != nil ? 1 : 0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "calendar")
                        .foregroundColor(date == nil ? .teal : .green)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(date == nil ? .teal : .green, lineWidth: 1)
                )
            }
            .accessibilityLabel("\(title) Button")
            .accessibilityHint("Appuyez pour sélectionner une date")
        }
    }
}
