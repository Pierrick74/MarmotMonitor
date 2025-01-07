//
//  FoodAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/12/2024.
//

import SwiftUI

/// Represents a view for adding food-related entries (e.g., breastfeeding, bottle feeding).
/// - Parameters:
///   - dynamicTypeSize: Adjusts the view to match the user's preferred text size.
///   - tab: Determines the selected tab (0 for breastfeeding, 1 for bottle feeding).
/// - Returns: A SwiftUI `View` that displays the corresponding input interface.
struct FoodAddView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var tab = 0

    private var manager = AppStorageManager.shared

    var body: some View {
        ZStack {
            VStack {
                // space available for the picker
                Rectangle().frame(height: 30)

                Group {
                    switch tab {
                    case 0:
                        BreastAddView()
                    case 1:
                        BottleAddView()
                    default:
                        BottleAddView()
                    }
                }
                .frame(maxHeight: .infinity)
                .environment(\.dynamicTypeSize, dynamicTypeSize)
                .animation(.easeInOut, value: tab)
            }
            .frame(maxHeight: .infinity)

            VStack {
                foodTypePicker
                Spacer()
            }
        }
    }

    private var foodTypePicker: some View {
        Picker("", selection: $tab) {
            Text("Allaitement")
                .tag(0)
            Text("Biberon")
                .tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 50)
        .padding(.top, 10)
        .background(manager.gender == GenderType.boy ?  .pastelBlueToEgiptienBlue : .pinkToEgiptienBlue)
    }
}

#Preview {
    FoodAddView()
}
