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
                                manager.saveSleep()

                                if manager.isSaveError == false {
                                    dismiss()
                                } else {
                                    showingAlert = true
                                }
                            }
                            .allowsHitTesting(manager.isActiveButtonSave)
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
                    Button("OK", role: .cancel) {
                        showingAlert = false
                    }
                } message: {
                    Text(manager.alertMessage)
                }
                .overlay(alignment: .topLeading) {
                    BackButton {
                        dismiss()
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
}

#Preview {
    SleepAddView()
}
