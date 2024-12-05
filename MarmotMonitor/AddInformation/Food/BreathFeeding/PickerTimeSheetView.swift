//
//  PickerTimeSheetView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2024.
//

import SwiftUI

struct PickerTimeSheetView: View {
    var title: String
    @Binding var selectedTime: Int
    @Binding var isPresented: Bool
    @State private var temporaryMinute: Int = 0

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundColor()
                VStack {
                    Text(title)
                        .font(.headline)
                        .padding()

                    Picker("Minutes", selection: $temporaryMinute) {
                                            ForEach(0..<60, id: \.self) { minute in
                                                Text("\(minute) min")
                                                    .tag(minute)
                                            }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .labelsHidden()
                                        .frame(height: 150) // Ajustez la hauteur si nécessaire
                                        .padding(.bottom, 20)

                    SaveButtonView(onSave: {
                        selectedTime = temporaryMinute * 60
                        isPresented = false
                    })
                    .padding([.bottom, .horizontal], 20)
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    PickerTimeSheetView(title: "Sélectionne le sommeil", selectedTime: .constant(0), isPresented: .constant(true))
}
