//
//  DateSelectionView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//
import SwiftUI

struct DateSelectionView: View {
    var title: String
    var date: Date?
    var buttonAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)

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
        }
    }
}
