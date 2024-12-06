//
//  ValueSelectionView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI

struct ValueSelectionView: View {
    var title: String
    @Binding var selectedNumber: Double?
    @Binding var isPresented: Bool

    @State private var number: Int = 10
    @State private var decimalNumber: Int = 0
    var range: ClosedRange<Date>?

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundColor()
                VStack {
                    Text(title)
                        .font(.headline)
                        .padding()

                    HStack(spacing: 0) {
                        Picker("Number of people", selection: $number) {
                            ForEach(0 ..< 150) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)

                        Text(".")
                            .font(.headline)

                        Picker("Number of people", selection: $decimalNumber) {
                            ForEach(0 ..< 100) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)

                    }

                    SaveButtonView(onSave: {
                        selectedNumber = Double(number) + Double(decimalNumber) / 100
                        isPresented = false
                    })
                    .padding([.bottom, .horizontal], 20)
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ValueSelectionView(title: "Sélectionne le nombre de personnes", selectedNumber: .constant(nil), isPresented: .constant(true))
}
