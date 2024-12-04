//
//  BreathAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

struct BreathAddView: View {
    @State private var timerG: TimerObject = TimerObject()
    @State private var timerD: TimerObject = TimerObject()

    var body: some View {
          
                ZStack {
                    BackgroundColor()
                    ScrollView {
                    VStack {
                        Spacer()
                        Text("Temps total")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("00:00")
                            .font(.title)
                            .fontWeight(.bold)

                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundColor(.primary)

                        Rectangle()
                            .frame(height: 50)
                            .foregroundColor(.clear)

                        HStack {
                            VStack {
                                TimerView(timer: timerG, color: .pastelBlueToEgiptienBlue, title: "Gauche")
                                    .padding(.horizontal, 10)

                                Button (action: {
                                    
                                }, label: {
                                    Text("saisir manuellement")
                                })
                                .buttonStyle(.bordered)
                                .foregroundColor(.primary)
                            }
                            VStack {
                                TimerView(timer: timerD, color: .pastelBlueToEgiptienBlue, title: "Droite")
                                    .padding(.horizontal, 10)
                                Button (action: {
                                    
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
                            date: Date(),
                            buttonAction: {  }
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
        }
}

#Preview {
    BreathAddView()
}
