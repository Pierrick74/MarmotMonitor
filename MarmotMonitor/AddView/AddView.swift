//
//  AddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2024.
//

import SwiftUI

struct AddView: View {
    let items: [GridItemData] = [
        GridItemData(icon: "Sommeil", text: "Sommeil", color: .sommeil),
        GridItemData(icon: "Couche", text: "Couche", color: .couche),
        GridItemData(icon: "Repas", text: "Biberon", color: .repas),
        GridItemData(icon: "cuillere", text: "Repas", color: .repas),
        GridItemData(icon: "allaitement", text: "Allaitement", color: .repas),
        GridItemData(icon: "Croissance", text: "Croissance", color: .croissance)
    ]

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        ZStack {
            BackgroundColor()
            if dynamicTypeSize < .accessibility1 {
                ScrollView {
                    GeometryReader { geo in
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(items) { item in
                                VStack(spacing: 0) {
                                    Image(decorative: item.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width / 4, height: geo.size.width / 4)
                                        .foregroundColor(item.color)
                                        .padding(.top, 5)
                                    Text(item.text)
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.primary)
                                        .padding(.bottom, 10)
                                        .accessibilityHint("insérer les informations pour \(item.text)")
                                }
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25 )
                                            .fill(.black)
                                            .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                                            .offset(x: 1, y: 1)

                                        RoundedRectangle(cornerRadius: 25 )
                                            .fill(item.color)
                                            .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .ignoresSafeArea()
                }
            } else {
                List(items) { item in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(item.color)
                        HStack {
                            Image(decorative: item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.top, 5)
                            Text(item.text)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.vertical, 5)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

// Structure pour représenter un élément de grille
struct GridItemData: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
}

#Preview {
    AddView()
}
