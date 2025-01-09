//
//  AccessibilityBottle.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 30/11/2024.
//

import SwiftUI
/// A view for accessibility person for bottle management
/// - Parameters:
/// - volume: The current volume of the bottle
/// - actionPlus: The action to add volume
/// - actionMinus: The action to remove volume

struct AccessibilityBottle: View {
    @Binding var volume: Int
    var actionPlus: () -> Void = {}
    var actionMinus: () -> Void = {}

    var body: some View {
        VStack {
            Text("\(volume)" + " ml")
                .font(.title)
                .padding()
            HStack(spacing: 50) {
                Button(action: {
                    actionMinus()
                }, label: {
                    Image(systemName: "minus.circle")
                        .font(.largeTitle)
                        .tint(.red)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.red.opacity(0.2)))
                        .accessibilityLabel("Retirer 10 ml")
                })
                Button(action: {
                    actionPlus()
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .tint(.green)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.green.opacity(0.2)))
                        .accessibilityLabel("Ajouter 10 ml")
                })
            }
        }
    }
}

#Preview {
    AccessibilityBottle(volume: .constant(100))
}
