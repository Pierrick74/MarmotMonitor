//
//  BottleAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 28/11/2024.
//

import SwiftUI

struct BottleAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    @StateObject var manager = BottleAddViewManager()
    // sheet presentation
    @State private var isEndPickerPresented: Bool = false
    @State private var showingAlert: Bool = false

    var body: some View {
        GeometryReader { geo in
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let relativeY = 1.0 - Double(value.location.y / geo.size.height) - 0.27
                    let acceleratedAmount = relativeY * 2.25
                    let amount = max(0, min(100, acceleratedAmount * 100))
                    manager.setPercent(amount)
                }
            ZStack {
                VStack {
                    ZStack(alignment: .bottom) {
                        VStack {

                            WaveAnimation(percent: $manager.percent)
                                .frame(height: geo.size.height * 0.45)

                            Rectangle()
                                .frame(height: geo.size.height * 0.25)
                        }

                        VStack(spacing: 0) {
                            ZStack {
                                BackgroundColor()

                                VStack {
                                    Spacer()
                                    if dynamicTypeSize < .accessibility1 {
                                        HStack {
                                            Image(decorative: "biberonForFill")
                                                .resizable()
                                                .frame(width: 200, height: geo.size.height * 0.7)
                                                .blendMode(.destinationOut)

                                            BottleIndicator(height: manager.heightIndicator, texte: manager.volumeInformation)
                                        }
                                    } else {
                                        AccessibilityBottle(volume: $manager.volume,
                                                            actionPlus: manager.incrementVolume,
                                                            actionMinus: manager.decrementVolume)
                                            .padding()
                                    }

                                    DateSelectionView(
                                        title: "Heure du change",
                                        date: manager.date,
                                        buttonAction: { isEndPickerPresented = true }
                                    )
                                    .accessibilityLabel("Sélectionnez l'heure de fin")
                                    .padding(.horizontal, 20)

                                    Spacer()

                                    SaveButtonView {
                                        manager.saveBottle()
                                        if manager.isSaveError == false {
                                            dismiss()
                                        } else {
                                            showingAlert = true
                                        }
                                    }
                                    .padding(.top, 20)
                                }
                            }
                            .compositingGroup()
                        }
                        .shadow(radius: 20, x: 5, y: 5)

                        if dynamicTypeSize < .accessibility1 {
                            VStack {
                                Rectangle()
                                    .opacity(0.00001)
                                    .frame(width: geo.size.width, height: geo.size.height * 0.75)
                                    .gesture(dragGesture)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEndPickerPresented) {
            PickerDateSheetView(
                title: "Selectionnez l'heure du biberon",
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
    BottleAddView()
}
