//
//  BabyBirthdayView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/11/2024.
//

import SwiftUI

struct BabyBirthdayView: View {
    @Environment(\.colorScheme) var colorScheme

    let action: () -> Void
    let actionBack: () -> Void

    @Binding var babyBirthday: Date

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.30)

                    ZStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Spacer()
                                .frame(height: 10)

                            Text("Quand est née la petite marmotte ?")
                                .onBoardingTextStyle()

                            DatePicker("", selection: $babyBirthday, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                        }
                        .onBoardingBackground()

                        HStack {
                            Spacer()
                            Image(decorative: "marmotWithPen")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .padding(.horizontal, 20)
                                .offset(x: 0, y: -100)
                        }
                    }

                    Button(action: action) {
                        Text("C'est parti !")
                    }
                    .buttonStyle(OnBoardingButtonStyle())
                }
                .padding(.horizontal, 20)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .overlay(alignment: .topLeading) {
            Button(action: actionBack) {
                Image(systemName: "chevron.backward")
            }
            .buttonStyle(OnBoardingBackButtonStyle())
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BabyBirthdayView(action: {}, actionBack: {}, babyBirthday: .constant(.now))
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
