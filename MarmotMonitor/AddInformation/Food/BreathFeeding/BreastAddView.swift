//
//  BreastAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

/// View for adding breast feeding time
/// - Parameters:
/// - `timerLeft`: Timer for left breast
struct BreastAddView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss

    @StateObject private var manager = BreastAddViewManager()

    @State private var isEndPickerPresented: Bool = false
    @State private var isLeftManuallySet: Bool = false
    @State private var isRightManuallySet: Bool = false
    @State private var showingAlert: Bool = false

    /// Binding for the breast selection
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
                    headerView
                    pickerView

                    if dynamicTypeSize < .accessibility1 {
                        globalTimerView
                    } else {
                        globalTimerViewAccessibility
                    }

                    Spacer()
                    bottomView
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
            .sheetStyle
        }
        .sheet(isPresented: $isLeftManuallySet) {
            PickerTimeSheetView(
                title: "Selectionne le temps à gauche",
                selectedTime: $manager.timerLeft.timeElapsed,
                isPresented: $isLeftManuallySet
            )
            .sheetStyle
        }
        .sheet(isPresented: $isRightManuallySet) {
            PickerTimeSheetView(
                title: "Selectionne le temps à droite",
                selectedTime: $manager.timerRight.timeElapsed,
                isPresented: $isRightManuallySet
            )
            .sheetStyle
        }
    }

    private var headerView: some View {
        VStack {
            Text("Temps total")
                .font(.title)
                .fontWeight(.bold)
                .accessibilityHidden(true)

            Text(manager.totalTime)
                .font(.title)
                .fontWeight(.bold)
                .contentTransition(.numericText())
                .animation(.linear, value: manager.totalTime)
                .accessibilityLabel(manager.totalTimeAccessibilityLabel)

            Rectangle()
                .frame(width: 100, height: 1)
                .foregroundColor(.primary)
        }
    }

    private var pickerView: some View {
        VStack {

            Text("Sélectionner le premier sein")
                .font(.body)
                .fontWeight(.bold)
                .padding(.top, 10)
                .accessibilityHidden(true)

            Picker("Sélectionnez le premier sein", selection: breastBinding) {
                Text("Gauche").tag(0)
                    .accessibilityHint("Sélectionnez le premier sein qui commence la session")
                Text("Droit").tag(1)
                    .accessibilityHint("Sélectionnez le premier sein qui commence la session")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 10)
        }
    }

    private var leftTimerView: some View {
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
            .accessibilityLabel("Saisir manuellement le temps passé à gauche")
        }
    }

    private var rightTimerView: some View {
        VStack {
            TimerView(timer: $manager.timerRight, color: .pastelBlueToEgiptienBlue, title: "Droite")
                .padding(.horizontal, 10)

            Button(action: { isRightManuallySet = true
            }, label: {
                Text("saisir manuellement")
            })
            .buttonStyle(.bordered)
            .foregroundColor(.primary)
            .accessibilityLabel("Saisir manuellement le temps passé à droite")
        }
    }

    private var globalTimerView: some View {
        HStack {
            leftTimerView
            rightTimerView
        }
        .padding(.bottom)
    }

    private var globalTimerViewAccessibility: some View {
        VStack {
            leftTimerView
            rightTimerView
        }
        .padding(.bottom)
    }

    private var bottomView: some View {
        VStack {
            DateSelectionView(
                title: "Heure du change",
                date: manager.date,
                buttonAction: {  isEndPickerPresented = true  }
            )
            .accessibilityHint("Sélectionnez l'heure de fin")
            .accessibilityValue("\(manager.accessibilityHintForDate)")

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
    }
}

#Preview {
    BreastAddView()
}
