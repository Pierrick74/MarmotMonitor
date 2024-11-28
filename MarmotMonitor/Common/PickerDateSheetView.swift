//
//  PickerDateSheetView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI

// Sous-vue pour afficher un Picker dans une feuille
// Permet de choisir une date

struct PickerDateSheetView: View {
    var title: String
    @Binding var selectedDate: Date?
    @Binding var isPresented: Bool
    @State private var temporaryDate: Date = Date()
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

                    DatePicker("",
                               selection: $temporaryDate,
                               in: range ?? Date.distantPast...Date.distantFuture,
                               displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(.bottom, 20)

                    SaveButtonView(onSave: {
                        selectedDate = temporaryDate
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
    PickerDateSheetView(title: "Sélectionne le sommeil", selectedDate: .constant(nil), isPresented: .constant(true))
}
