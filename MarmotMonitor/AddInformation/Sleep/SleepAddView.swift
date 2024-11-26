//
//  SleepView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/11/2024.
//

import SwiftUI

struct SleepAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @StateObject var manager = SleepAddViewManager()

    // sheet presentation
    @State private var isStartPickerPresented: Bool = false
    @State private var isEndPickerPresented: Bool = false
    @State private var showingAlert: Bool = false

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
                                date: manager.startDate,
                                buttonAction: { isStartPickerPresented = true }
                            )
                            .accessibilityLabel("Sélectionnez l'heure de début")
                            .accessibilityHint(manager.accessibilityHintForStartDate)

                            DateSelectionView(
                                title: "Heure de fin",
                                date: manager.endDate,
                                buttonAction: { isEndPickerPresented = true }
                            )
                            .accessibilityLabel("Sélectionnez l'heure de fin")
                            .accessibilityHint(manager.accessibilityHintForEndDate)

                            Spacer()

                            SaveButtonView {
                                dismiss()
                            } onSave: {
                                manager.saveSleep()

                                if manager.isSaveError == false {
                                    dismiss()
                                } else {
                                    showingAlert = true
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
                        selectedDate: $manager.startDate,
                        isPresented: $isStartPickerPresented,
                        range: manager.startRange
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }

                .sheet(isPresented: $isEndPickerPresented) {
                    PickerDateSheetView(
                        title: "Select End Time",
                        selectedDate: $manager.endDate,
                        isPresented: $isEndPickerPresented,
                        range: manager.endRange
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }
                .alert(
                    "Alerte",
                    isPresented: $showingAlert
                ) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Activité déja présente dans cette horraire")
                }
                .navigationBarBackButtonHidden(true)
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
    SleepAddView()
}
