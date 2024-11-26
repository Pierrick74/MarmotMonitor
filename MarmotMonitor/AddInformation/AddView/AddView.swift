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
        GridItemData(icon: "Repas", text: "Biberon", color: .repas, destination: .biberon),
        GridItemData(icon: "cuillere", text: "Repas", color: .repas, destination: .repas),
        GridItemData(icon: "allaitement", text: "Allaitement", color: .repas, destination: .allaitement),
        GridItemData(icon: "Croissance", text: "Croissance", color: .croissance, destination: .croissance)
    ]

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) var dismiss

    var body: some View {
            NavigationStack {
                ZStack {
                    BackgroundColor()

                    VStack {
                        if dynamicTypeSize < .accessibility1 {
                            ScrollView {
                                GeometryReader { geo in
                                    LazyVGrid(columns: columns, spacing: 30) {
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

                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Fermer")
                        }
                        )

                    }
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
    case biberon
    case repas
    case allaitement
    case croissance
}

#Preview {
    AddView()
}
