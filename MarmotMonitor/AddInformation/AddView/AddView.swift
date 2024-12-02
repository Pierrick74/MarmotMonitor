//
//  AddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2024.
//

import SwiftUI

struct AddView: View {
    let items: [GridItemData] = [
        GridItemData(icon: "Sommeil", text: "Sommeil", color: .sommeil, destination: .sommeil),
        GridItemData(icon: "Couche", text: "Couche", color: .couche, destination: .couche),
        GridItemData(icon: "Repas", text: "Lait", color: .repas, destination: .repas),
        GridItemData(icon: "Croissance", text: "Croissance", color: .croissance, destination: .croissance)
    ]

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundColor()

                VStack(alignment: .center) {
                    Text("Ajouter une activité")
                        .font(.title)
                        .foregroundColor(.primary)
                    if dynamicTypeSize < .accessibility1 {
                        Image("folder")
                            .resizable()
                            .scaledToFit()
                    }

                    if dynamicTypeSize < .accessibility1 {
                        ScrollView {
                            GeometryReader { geo in
                                LazyVGrid(columns: columns, spacing: 32) {
                                    ForEach(items) { item in
                                        NavigationLink(destination: DestinationView(destination: item.destination)) {
                                            ItemView(item: item, width: geo.size.width)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .scrollBounceBehavior(.basedOnSize)
                            .ignoresSafeArea()
                        }
                    } else {
                        List(items) { item in
                            NavigationLink(destination: DestinationView(destination: item.destination)) {
                                AccessibilityItemView(item: item)
                            }
                            .padding(.vertical, 5)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding()
            }
        }
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
        }
    }
}

struct GridItemData: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
    let destination: ItemDestination
}

enum ItemDestination: Hashable {
    case sommeil
    case couche
    case repas
    case croissance
}

#Preview {
    AddView()
}
