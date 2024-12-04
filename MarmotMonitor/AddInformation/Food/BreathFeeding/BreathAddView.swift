//
//  BreathAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

struct BreathAddView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @StateObject private var manager = BreathAddViewManager()

    @State private var isEndPickerPresented: Bool = false
    @State private var isLeftManuallySet: Bool = false
    @State private var isRightManuallySet: Bool = false
    @State private var showingAlert: Bool = false

    var body: some View {

                ZStack {
                    BackgroundColor()
                    ScrollView {
                    VStack {
                        Spacer()
                        Text("Temps total")
                            .font(.title)
                            .fontWeight(.bold)

                        Text(manager.totalTime)
                            .font(.title)
                            .fontWeight(.bold)
                            .contentTransition(.numericText())
                            .animation(.linear, value: manager.totalTime)

                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundColor(.primary)

                        Rectangle()
                            .frame(height: 50)
                            .foregroundColor(.clear)

                        HStack {
                            VStack {
                                TimerView(timer: manager.timerG, color: .pastelBlueToEgiptienBlue, title: "Gauche")
                                    .padding(.horizontal, 10)

                                Button (action: { isLeftManuallySet = true
                                }, label: {
                                    Text("saisir manuellement")
                                })
                                .buttonStyle(.bordered)
                                .foregroundColor(.primary)
                            }
                            VStack {
                                TimerView(timer: manager.timerD, color: .pastelBlueToEgiptienBlue, title: "Droite")
                                    .padding(.horizontal, 10)
                                Button (action: { isRightManuallySet = true
                                }, label: {
                                    Text("saisir manuellement")
                                })
                                .buttonStyle(.bordered)
                                .foregroundColor(.primary)
                            }
                        }
                        .padding(.bottom)

                        Spacer()

                        DateSelectionView(
                            title: "Heure du change",
                            date: manager.date,
                            buttonAction: {  isEndPickerPresented = true  }
                        )
                        .accessibilityLabel("Sélectionnez l'heure de fin")
                        .accessibilityHint("manager.accessibilityHintForDate")

                        SaveButtonView {
                        }
                        .padding()
                    }
                    .padding()
                }
                    .navigationBarBackButtonHidden(true)
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
                .sheet(isPresented: $isLeftManuallySet) {
                    PickerTimeSheetView(
                        title: "Selectionne le temps à gauche",
                        selectedTime: $manager.timerG.timeElapsed,
                        isPresented: $isLeftManuallySet
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }
                .sheet(isPresented: $isRightManuallySet) {
                    PickerTimeSheetView(
                        title: "Selectionne le temps à droite",
                        selectedTime: $manager.timerD.timeElapsed,
                        isPresented: $isRightManuallySet
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }
        }
}

#Preview {
    BreathAddView()
}
