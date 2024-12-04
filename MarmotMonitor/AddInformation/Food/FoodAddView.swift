//
//  FoodAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/12/2024.
//

import SwiftUI

struct FoodAddView: View {
    @State private var tab = 0
    private var manager = AppStorageManager.shared

    var body: some View {
        ZStack {
            VStack {
                Rectangle().frame(height: 30)

                Group {
                    switch tab {
                    case 0:
                        BreathAddView()
                            .frame(maxHeight: .infinity)
                    case 1:
                        BottleAddView()
                            .frame(maxHeight: .infinity)
                    default:
                        BottleAddView()
                    }
                }
                .animation(.easeInOut, value: tab)
            }
            .frame(maxHeight: .infinity)

            VStack {
                // Picker pour la sélection
                Picker("", selection: $tab) {
                    Text("Allaitement")
                        .tag(0)
                    Text("Biberon")
                        .tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 50)
                .padding(.top, 10)
                .background(manager.gender == GenderType.boy.rawValue ?  .pastelBlueToEgiptienBlue : .pinkToEgiptienBlue)

                Spacer()
            }
        }
    }
}

#Preview {
    FoodAddView()
}
