//
//  AddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2024.
//

import SwiftUI

struct AddView: View {
    // Configuration des éléments (icône, texte, et couleur)
    let items: [GridItemData] = [
        GridItemData(icon: "Sommeil", text: "Sommeil", color: .pink),
        GridItemData(icon: "Couche", text: "Couche", color: .orange),
        GridItemData(icon: "Repas", text: "Biberon", color: .blue),
        GridItemData(icon: "Repas", text: "Repas Solide", color: .purple),
        GridItemData(icon: "allaitement", text: "Allaitement", color: .orange),
        GridItemData(icon: "Croissance", text: "Croissance", color: .blue)
    ]

    // Configuration de la grille
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            GeometryReader { geo in
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(items) { item in
                        VStack {
                            Circle()
                                .fill(item.color.opacity(0.2))
                                .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                                .overlay(
                                    Image(item.icon)
                                        .resizable()
                                        .frame(width: geo.size.width / 4, height: geo.size.width / 4)
                                        .scaledToFit()
                                        .foregroundColor(item.color)
                                )
                            Text(item.text)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// Structure pour représenter un élément de grille
struct GridItemData: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
}

#Preview {
    AddView()
}
