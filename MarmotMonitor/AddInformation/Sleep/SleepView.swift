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
    // États pour la sélection des dates
    @State private var startDate: Date?
    @State private var endDate: Date?

    // États pour afficher les feuilles modales
    @State private var isStartPickerPresented: Bool = false
    @State private var isEndPickerPresented: Bool = false

    var body: some View {
        ZStack {
            BackgroundColor()

            VStack(spacing: 30) {
                Image(decorative: "Sommeil")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.teal)

                // Titre principal
                Text("Sélectionne le sommeil")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Section pour l'heure de début
                VStack(alignment: .leading, spacing: 10) {
                    Text("Heure de début")
                        .font(.headline)

                    Button(action: {
                        isStartPickerPresented = true
                    }, label: {
                        HStack {
                            Text(startDate != nil ? startDate!.formatted(date: .numeric, time: .shortened) : "Appuyer pour selectionner")
                                .foregroundColor(startDate != nil ? .black : .gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "calendar")
                                .foregroundColor(.teal)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.teal, lineWidth: 1))
                    })
                }

                // Section pour l'heure de fin
                VStack(alignment: .leading, spacing: 10) {
                    Text("End Time")
                        .font(.headline)

                    Button(action: {
                        isEndPickerPresented = true
                    }, label: {
                        HStack {
                            Text(endDate != nil ? endDate!.formatted(date: .abbreviated, time: .shortened) : "Appuyer pour selectionner")
                                .foregroundColor(endDate != nil ? .black : .gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "calendar")
                                .foregroundColor(.teal)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.teal, lineWidth: 1))
                    })
                }

                Spacer()

                // Bouton "Save"
                HStack(spacing: 20) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Annuler")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.mix(with: .white, by: 0.5))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                    })
                    .frame(maxWidth: UIScreen.main.bounds.width / 4)
                    .padding(.bottom, 20)

                    Button(action: {
                        saveNapDetails()
                    }, label: {
                        Text("Save")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.mix(with: .white, by: 0.5))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                    })
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
                    .padding(.bottom, 20)
                }

                // Affichage des résultats enregistrés
                if let startDate = startDate, let endDate = endDate {
                    VStack(spacing: 10) {
                        Text("Start: \(startDate.formatted(date: .long, time: .shortened))")
                        Text("End: \(endDate.formatted(date: .long, time: .shortened))")
                    }
                    .padding(.top, 20)
                }
            }
            .padding()
        }
        .sheet(isPresented: $isStartPickerPresented) {
            PickerDateSheetView(
                title: "Select Start Time",
                selectedDate: $startDate,
                isPresented: $isStartPickerPresented
            )
            .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
            .environment(\.dynamicTypeSize, dynamicTypeSize)
            .presentationCornerRadius(30)
        }

        .sheet(isPresented: $isEndPickerPresented) {
            PickerDateSheetView(
                title: "Select End Time",
                selectedDate: $endDate,
                isPresented: $isEndPickerPresented
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

#Preview {
    SleepView()
}
