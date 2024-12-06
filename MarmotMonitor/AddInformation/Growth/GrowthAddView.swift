//
//  GrowthAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/12/2024.
//

import SwiftUI

struct GrowthAddView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) var dismiss

    @State private var isEndPickerPresented: Bool = false
    @State private var isSizePresented: Bool = false
    @State private var isWeightPresented: Bool = false
    @State private var isHeadSizePresented: Bool = false

    @State private var showingAlert: Bool = false

    @StateObject var manager = GrowthAddViewManager()

    var body: some View {
            ZStack {
                BackgroundColor()
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Croissance")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(20)

                        CustomTextField(
                            title: "Taille",
                            action: {isSizePresented = true},
                            placeholder: "Appuyer pour entrer la taille",
                            value: manager.heightDescription
                        )

                        CustomTextField(
                            title: "Poids",
                            action: {isWeightPresented = true},
                            placeholder: "Appuyer pour entrer le poids",
                            value: manager.weightDescription
                        )

                        CustomTextField(
                            title: "Périmètre crânien",
                            action: {isHeadSizePresented = true},
                            placeholder: "Appuyer pour entrer le périmètre crânien",
                            value: manager.headSizeDescription
                        )

                        DateSelectionView(
                            title: "Date",
                            date: manager.date,
                            buttonAction: { isEndPickerPresented = true }
                        )
                        .accessibilityLabel("Sélectionnez l'heure de fin")
                        .accessibilityHint("")
                        .padding(.top, 20)

                        SaveButtonView {
                            manager.saveGrowth()
                            if manager.isSaveError == false {
                                dismiss()
                            } else {
                                showingAlert = true
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                    .scrollBounceBehavior(.basedOnSize)
                }
                .padding(.top, 20)
            .sheet(isPresented: $isEndPickerPresented) {
                PickerDateSheetView(
                    title: "Select End Time",
                    selectedDate: $manager.date,
                    isPresented: $isEndPickerPresented,
                    range: manager.range
                )
                .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                .environment(\.dynamicTypeSize, dynamicTypeSize)
                .presentationCornerRadius(30)
            }
            .sheet(isPresented: $isSizePresented) {
                ValueSelectionView(
                    title: "Taille en " + manager.sizeUnit,
                    selectedNumber: $manager.height,
                    isPresented: $isSizePresented
                )
                .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                .environment(\.dynamicTypeSize, dynamicTypeSize)
                .presentationCornerRadius(30)
            }
            .sheet(isPresented: $isWeightPresented) {
                ValueSelectionView(
                    title: "Poids en " + manager.weightUnit,
                    selectedNumber: $manager.weight,
                    isPresented: $isWeightPresented
                )
                .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                .environment(\.dynamicTypeSize, dynamicTypeSize)
                .presentationCornerRadius(30)
            }
            .sheet(isPresented: $isHeadSizePresented) {
                ValueSelectionView(
                    title: "Taille en " + manager.sizeUnit,
                    selectedNumber: $manager.headSize,
                    isPresented: $isHeadSizePresented
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
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GrowthAddView()
}
