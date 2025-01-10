//
//  PickerDateSheetView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2024.
//

import SwiftUI

/// A view that presents a date picker in a sheet with customizable options.
///
/// Allows users to select a date within an optional range. The selected date is saved when the user taps the save button.
///
/// - Parameters:
///   - title: The title displayed at the top of the sheet.
///   - selectedDate: A binding to the date selected by the user. Defaults to `nil`.
///   - isPresented: A binding to control the visibility of the sheet.
///   - range: An optional range of dates to constrain the date picker.
/// - Returns: A view that displays a date picker inside a customizable sheet.
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
