//
//  InformationRow.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI

struct InformationRow: View {
    @ObservedObject private var manager = AppStorageManager.shared
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.primary)
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
            Spacer()
            Text("Modifier")
                .font(.body)
                .fontWeight(.bold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .primary, radius: 2, x: 0, y: 2)
        )
        .padding()
    }
}

#Preview {
    InformationRow()
        .background(Color.red)
}
