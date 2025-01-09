//
//  ValueSelectionView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI
/// A view that allows users to select a numeric value (integer and decimal parts) within a picker interface.
/// - Parameters:
///   - title: The title displayed at the top of the view.
///   - selectedNumber: A binding to the selected numeric value (optional).
///   - isPresented: A binding that determines whether the view is presented.
///   - range: An optional range of dates (not currently used but available for extension).
/// - Returns: A SwiftUI `View` for selecting numeric values.
struct ValueSelectionView: View {
    // MARK: - Properties
    var title: String
    var range: ClosedRange<Date>?

    @Binding var selectedNumber: Double?
    @Binding var isPresented: Bool

    @State private var number: Int = 10
    @State private var decimalNumber: Int = 50

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
                        .accessibilityHidden(true)

                    numberPicker

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

    private var numberPicker: some View {
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
    }
}

#Preview {
    ValueSelectionView(title: "Sélectionne le nombre de personnes", selectedNumber: .constant(nil), isPresented: .constant(true))
}
