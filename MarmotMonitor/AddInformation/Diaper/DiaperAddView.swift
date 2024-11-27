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

    @StateObject var manager = SleepAddViewManager()

    // sheet presentation
    @State private var isWet: Bool = false
    @State private var isPoo: Bool = false
    @State private var isEndPickerPresented: Bool = false

    var diaperColor: [Color] {
        if isWet && isPoo {
            return [Color.yellow, Color(uiColor: .diaperButton), Color(.lightGray)]
        } else if isWet {
            return [Color.yellow, Color(.lightGray)]
        } else if isPoo {
            return [Color(uiColor: .diaperButton), Color(.lightGray)]
        } else {
            return [Color(.lightGray)]
        }
    }
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
                                .fill(RadialGradient(gradient: Gradient(colors: diaperColor),
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
                        date: manager.endDate,
                        buttonAction: { isEndPickerPresented = true }
                    )
                    .accessibilityLabel("Sélectionnez l'heure de fin")
                    .accessibilityHint(manager.accessibilityHintForEndDate)

                    HStack(spacing: 50) {
                        Button(action: {
                            withAnimation {
                                isWet.toggle()
                            }
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(isWet ? Color.yellow.gradient : Color.gray.gradient)
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
                                isPoo.toggle()
                            }
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(isPoo ? Color(.diaperButton).gradient : Color(.lightGray).gradient)
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
                        manager.saveSleep()
                            dismiss()
                    }
                }
                .padding()
                .scrollBounceBehavior(.basedOnSize)
            }

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
        .overlay(alignment: .topLeading) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                    .font(.body)
                    .padding(8)
                    .tint(.primary)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Circle())
                    .padding(.horizontal, 10)
                    .shadow(radius: 3, x: 3, y: 3)
            })
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DiaperAddView()
}
