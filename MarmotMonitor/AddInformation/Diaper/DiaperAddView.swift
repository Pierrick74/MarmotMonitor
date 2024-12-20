//
//  DiaperAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2024.
//

import SwiftUI

struct DiaperAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @StateObject var manager = DiaperAddViewManager()

    // sheet presentation
    @State private var isEndPickerPresented: Bool = false
    @State private var showingAlert: Bool = false

    var body: some View {
        ZStack {
            BackgroundColor()

            ScrollView {
                VStack(spacing: 30) {
                    // Titre principal
                    Text("Quelle est l'état de la couche")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(20)

                    // start date section
                    ZStack {
                            RoundedRectangle(cornerRadius: 30)
                            .fill(RadialGradient(gradient: Gradient(colors: manager.diaperColor),
                                                      center: .bottom,
                                                      startRadius: 0,
                                                      endRadius: 300))
                                .mask(
                                Image(decorative: "diaperFill")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(.teal)
                                )
                    }
                    .frame(height: 200)

                    DateSelectionView(
                        title: "Heure du change",
                        date: manager.date,
                        buttonAction: { isEndPickerPresented = true }
                    )
                    .accessibilityLabel("Sélectionnez l'heure de fin")
                    .accessibilityHint(manager.accessibilityHintForDate)

                    HStack(spacing: 50) {
                        Button(action: {
                            withAnimation {
                                manager.isWet.toggle()
                            }
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(manager.isWet ? Color.yellow.gradient : Color.gray.gradient)
                                    .frame(height: 100)
                                Image("urine")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .padding(20)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                            .shadow(radius: 2, x: 2, y: 2)
                        })

                        Button(action: {
                            withAnimation {
                                manager.isDirty.toggle()
                            }
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(manager.isDirty ? Color(.diaperButton).gradient : Color(.lightGray).gradient)
                                        .frame(height: 100)
                                    Image("selles")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .padding(20)
                                        .blendMode(.destinationOut)
                                }
                                .compositingGroup()
                                .shadow(radius: 2, x: 2, y: 2)
                        })
                    }
                    Spacer()

                    SaveButtonView {
                        manager.saveDiaper()
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
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
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
        .navigationBarBackButtonHidden(true)
        .onAppear {manager.date = .now}
    }
}

#Preview {
    DiaperAddView()
}
