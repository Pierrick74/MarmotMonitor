//
//  SleepView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/11/2024.
//

import SwiftUI

struct SleepView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // date storage
    @State private var startDate: Date?
    @State private var endDate: Date?

    // sheet presentation
    @State private var isStartPickerPresented: Bool = false
    @State private var isEndPickerPresented: Bool = false

    var body: some View {
                ZStack {
                    BackgroundColor()

                    ScrollView {
                        VStack(spacing: 30) {
                            if dynamicTypeSize < .accessibility1 {
                                Image(decorative: "Sommeil")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(.teal)
                            }

                            // Titre principal
                            Text("Sélectionne le sommeil")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 20)

                            // start date section
                            DateSelectionView(
                                title: "Heure de début",
                                date: startDate,
                                buttonAction: { isStartPickerPresented = true }
                            )
                            .accessibilityLabel("Sélectionnez l'heure de début")
                            .accessibilityHint(
                                startDate != nil ?
                                "Heure actuelle : \(startDate!.formatted(date: .abbreviated, time: .shortened))"
                                : "Valeur Non définie"
                            )

                            DateSelectionView(
                                title: "Heure de fin",
                                date: endDate,
                                buttonAction: { isEndPickerPresented = true }
                            )
                            .accessibilityLabel("Sélectionnez l'heure de fin")
                            .accessibilityHint(
                                endDate != nil ?
                                "Heure actuelle : \(startDate!.formatted(date: .abbreviated, time: .shortened))"
                                : "Valeur Non définie"
                            )

                            Spacer()

                            SaveButtonView {
                                dismiss()
                            } onSave: {
                                if startDate != nil && endDate != nil {
                                    saveNapDetails()
                                }
                            }
                        }
                        .padding()
                        .scrollBounceBehavior(.basedOnSize)
                    }

                }
                .sheet(isPresented: $isStartPickerPresented) {
                    PickerDateSheetView(
                        title: "Select Start Time",
                        selectedDate: $startDate,
                        isPresented: $isStartPickerPresented,
                        range: Date.distantPast...Date.now
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }

                .sheet(isPresented: $isEndPickerPresented) {
                    PickerDateSheetView(
                        title: "Select End Time",
                        selectedDate: $endDate,
                        isPresented: $isEndPickerPresented,
                        range: (startDate != nil) ? startDate!...Date.distantFuture : nil
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }
                .navigationBarBackButtonHidden(true)
            }

    // Fonction pour sauvegarder les détails
    private func saveNapDetails() {
        print("Nap Details Saved:")
        if let startDate = startDate {
            print("Start: \(startDate)")
        }
        if let endDate = endDate {
            print("End: \(endDate)")
        }
    }
}

struct DateSelectionView: View {
    var title: String
    var date: Date?
    var buttonAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)

            Button(action: buttonAction) {
                HStack {
                    Text(date != nil ? date!.formatted(date: .abbreviated, time: .shortened) : "Appuyer pour sélectionner")
//                        .foregroundColor(date != nil ? .primary : .gray)
                        .foregroundColor(.primary.opacity(date != nil ? 1 : 0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "calendar")
                        .foregroundColor(date == nil ? .teal : .green)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(date == nil ? .teal : .green, lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    SleepView()
}
