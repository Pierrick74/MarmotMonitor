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

    var body: some View {
            NavigationStack {
                ZStack {
                    BackgroundColor()
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
                }
            }
        }
    }

    // Extracted views for better organization
    struct ItemView: View {
        let item: GridItemData
        let width: CGFloat

        var body: some View {
            VStack(spacing: 0) {
                Image(decorative: item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 4, height: width / 4)
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
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .frame(width: width / 3, height: width / 3)
                        .offset(x: 1, y: 1)

                    RoundedRectangle(cornerRadius: 25)
                        .fill(item.color)
                        .frame(width: width / 3, height: width / 3)
                }
            )
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

struct DestinationView: View {
    let destination: ItemDestination

    var body: some View {
        Group {
            switch destination {
            case .sommeil:
                SleepView()
            case .couche:
                SleepView()
            case .biberon:
                SleepView()
            case .repas:
                SleepView()
            case .allaitement:
                SleepView()
            case .croissance:
                SleepView()
            }
        }
    }
}

#Preview {
    AddView()
}
