//
//  InformationRow.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI

/// A row displaying information about the baby, including name, birth date, gender, and parent.
/// - Allows navigation to edit the displayed information.
struct InformationRow: View {
    // MARK: - dependencies
    @ObservedObject private var manager = AppStorageManager.shared

    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            infoIcon
            infoDetails
            Spacer()
            editInfo
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(colorScheme == .light ? .white : .clear)
                .stroke(colorScheme == .light ? .clear : .primary, lineWidth: 1)
                .shadow(color: .primary, radius: 2, x: 0, y: 2)
        )
        .padding()
    }

    // MARK: - Private Views
    private var infoIcon: some View {
        Image(systemName: "info.circle")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.primary)
    }

    private var infoDetails: some View {
        VStack(alignment: .leading) {
            Text(manager.babyName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text("Né le")
                .font(.body)
                .foregroundColor(.primary)
            Text(manager.babyBirthday, style: .date)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(manager.gender == GenderType.boy ? "Fils de "+manager.parentName : "Fille de " + manager.parentName)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var editInfo: some View {
        Text("Modifier")
            .font(.body)
            .fontWeight(.bold)
    }
}

#Preview {
    InformationRow()
        .background(Color.red)
}
