//
//  AddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2024.
//

import SwiftUI
/// A view that allows users to add a new activity by choosing from a list or grid of options.
/// - This view adapts its layout based on the user's dynamic type size setting.
/// - It supports both grid and list presentations, making it accessible for all users.

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
                        folderView
                        itemsInGrid
                    } else {
                        itemsInList
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

    // MARK: - Private Views
    private var folderView: some View {
        Image(decorative: "folder")
            .resizable()
            .scaledToFit()
    }

    private var itemsInList: some View {
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

    private var itemsInGrid: some View {
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
    }
}

/// A data model representing an item in the grid or list.
/// - Parameters:
///   - icon: The name of the icon representing the item.
///   - text: A descriptive text for the item.
///   - color: The background color associated with the item.
///   - destination: The destination view to navigate to when selected.
struct GridItemData: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
    let destination: ItemDestination
}

#Preview {
    AddView()
}
