//
//  DiaperAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2024.
//

import SwiftUI
/// A view for recording the status of a diaper change.
/// - Features include selecting the time of change, marking the diaper as wet or dirty,
///   and saving the record. The view adapts to accessibility settings.
/// - Parameters:
///  - Nil
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
                    Text("Quelle est l'état de la couche")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(20)

                    // Diaper State Visualization
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

                    // Buttons for marking the diaper as wet or dirty.
                    HStack(spacing: 50) {
                        DiaperStateButton(
                            isActive: $manager.isWet,
                            imageName: "urine",
                            activeColor: .yellow,
                            inactiveColor: .gray,
                            label: "Couche mouillée"
                        )

                        DiaperStateButton(
                            isActive: $manager.isDirty,
                            imageName: "selles",
                            activeColor: Color(.diaperButton),
                            inactiveColor: Color(.lightGray),
                            label: "Couche sale"
                        )
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

/// A reusable button for selecting diaper states (wet or dirty).
/// - Parameters:
///   - isActive: A binding to the active state of the button.
///   - imageName: The name of the image displayed inside the button.
///   - activeColor: The color of the button when active.
///   - inactiveColor: The color of the button when inactive.
///   - label: The accessibility label for the button.
struct DiaperStateButton: View {
    @Binding var isActive: Bool
    let imageName: String
    let activeColor: Color
    let inactiveColor: Color
    let label: String

    var body: some View {
        Button(action: {
            withAnimation {
                isActive.toggle()
            }
        }, label: {
            ZStack {
                Circle()
                    .fill(isActive ? activeColor.gradient : inactiveColor.gradient)
                    .frame(height: 100)
                Image(imageName)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(20)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            .shadow(radius: 2, x: 2, y: 2)
        })
        .accessibilityLabel(label)
    }
}

#Preview {
    DiaperAddView()
}
