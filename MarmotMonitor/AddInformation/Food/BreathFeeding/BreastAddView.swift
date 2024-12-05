//
//  BreastAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

struct BreastAddView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss

    @StateObject private var manager = BreastAddViewManager()

    @State private var isEndPickerPresented: Bool = false
    @State private var isLeftManuallySet: Bool = false
    @State private var isRightManuallySet: Bool = false
    @State private var showingAlert: Bool = false

    private var breastBinding: Binding<Int> {
            Binding(
                get: { manager.firstBreast == .left ? 0 : 1 },
                set: { manager.firstBreast = $0 == 0 ? .left : .right }
            )
        }

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

                        Text("Séléctionner le premier sein")
                            .font(.body)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        Picker("", selection: breastBinding) {
                            Text("Gauche")
                                .tag(0)
                            Text("Droit")
                                .tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 10)

                        if dynamicTypeSize < .accessibility1 {
                            HStack {
                                VStack {
                                    TimerView(timer: $manager.timerLeft, color: .pastelBlueToEgiptienBlue, title: "Gauche")
                                        .padding(.horizontal, 10)
                                        .environment(\.dynamicTypeSize, dynamicTypeSize)

                                    Button(action: { isLeftManuallySet = true
                                    }, label: {
                                        Text("saisir manuellement")
                                    })
                                    .buttonStyle(.bordered)
                                    .foregroundColor(.primary)
                                }
                                VStack {
                                    TimerView(timer: $manager.timerRight, color: .pastelBlueToEgiptienBlue, title: "Droite")
                                        .padding(.horizontal, 10)
                                    Button(action: { isRightManuallySet = true
                                    }, label: {
                                        Text("saisir manuellement")
                                    })
                                    .buttonStyle(.bordered)
                                    .foregroundColor(.primary)
                                }
                            }
                            .padding(.bottom)
                        } else {
                            VStack {
                                VStack {
                                    TimerView(timer: $manager.timerLeft, color: .pastelBlueToEgiptienBlue, title: "Gauche")
                                        .padding(.horizontal, 10)
                                        .environment(\.dynamicTypeSize, dynamicTypeSize)

                                    Button(action: { isLeftManuallySet = true
                                    }, label: {
                                        Text("saisir manuellement")
                                    })
                                    .buttonStyle(.bordered)
                                    .foregroundColor(.primary)
                                }
                                VStack {
                                    TimerView(timer: $manager.timerRight, color: .pastelBlueToEgiptienBlue, title: "Droite")
                                        .padding(.horizontal, 10)
                                    Button(action: { isRightManuallySet = true
                                    }, label: {
                                        Text("saisir manuellement")
                                    })
                                    .buttonStyle(.bordered)
                                    .foregroundColor(.primary)
                                }
                            }
                            .padding(.bottom)
                        }

                        Spacer()

                        DateSelectionView(
                            title: "Heure du change",
                            date: manager.date,
                            buttonAction: {  isEndPickerPresented = true  }
                        )
                        .accessibilityLabel("Sélectionnez l'heure de fin")
                        .accessibilityHint("manager.accessibilityHintForDate")

                        SaveButtonView {
                            manager.saveBreast()
                            if manager.isSaveError == false {
                                dismiss()
                            } else {
                                showingAlert = true
                            }
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
                        selectedTime: $manager.timerLeft.timeElapsed,
                        isPresented: $isLeftManuallySet
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }
                .sheet(isPresented: $isRightManuallySet) {
                    PickerTimeSheetView(
                        title: "Selectionne le temps à droite",
                        selectedTime: $manager.timerRight.timeElapsed,
                        isPresented: $isRightManuallySet
                    )
                    .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .presentationCornerRadius(30)
                }
        }
}

#Preview {
    BreastAddView()
}
