//
//  BottleAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 28/11/2024.
//

import SwiftUI
// A view for adding bootle feeding data
/// - Parameters:
/// - Nil
struct BottleAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    @StateObject var manager = BottleAddViewManager()

    // State for showing date picker and alerts
    @State private var isEndPickerPresented: Bool = false
    @State private var showingAlert: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    ZStack(alignment: .bottom) {
                        WaveView(
                            percent: $manager.percent,
                            geo: geo
                        )

                        VStack(spacing: 0) {
                            ZStack {
                                BackgroundColor()

                                VStack {
                                    Spacer()
                                    if dynamicTypeSize < .accessibility1 {
                                        ZStack {
                                            StandardBottleView(
                                                geo: geo,
                                                heightIndicator: $manager.heightIndicator,
                                                volumeInformation: $manager.volumeInformation
                                            )
                                            GestureView(
                                                geo: geo,
                                                action: { manager.percent = $0}
                                            )
                                        }
                                    } else {
                                        AccessibilityBottle(
                                            volume: $manager.volume,
                                            actionPlus: manager.incrementVolume,
                                            actionMinus: manager.decrementVolume
                                        )
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

/// A view for displaying the bottle and its indicator
/// - Parameters:
/// - geo: the geometry proxy for layout
/// - heightIndicator: the height of the bottle indicator
/// - volumeInformation: the volume information to display
struct StandardBottleView: View {
    let geo: GeometryProxy
    @Binding var heightIndicator: Double
    @Binding var volumeInformation: String

    var body: some View {
        HStack {
            Image(decorative: "biberonForFill")
                .resizable()
                .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.7)
                .blendMode(.destinationOut)

            BottleIndicator(height: heightIndicator, texte: volumeInformation)
        }
    }
}

/// A view for handling drag gestures on the bottle
/// - Parameters:
/// - geo: the geometry proxy for layout
/// - action: the action to perform on drag
struct GestureView: View {
    let geo: GeometryProxy
    let action: (Double) -> Void

    var body: some View {
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { value in
                let relativeY = 1.0 - Double(value.location.y / geo.size.height) - 0.27
                let acceleratedAmount = relativeY * 2.25
                let amount = max(0, min(100, acceleratedAmount * 100))
                action(amount)
            }
        VStack {
            Rectangle()
                .opacity(0.00001)
                .frame(width: geo.size.width, height: geo.size.height * 0.75)
                .gesture(dragGesture)
            Spacer()
        }
    }
}

/// A view for displaying the wave animation
/// - Parameters:
/// - percent: the percentage of the bottle filled
/// - geo: the geometry proxy for layout
/// - Returns: a view with wave animation

struct WaveView: View {
    @Binding var percent: Double
    let geo: GeometryProxy

    var body: some View {
        VStack {
            WaveAnimation(percent: $percent)
                .frame(height: geo.size.height * 0.45)

            Rectangle()
                .frame(height: geo.size.height * 0.25)
        }
    }
}

#Preview {
    BottleAddView()
}
