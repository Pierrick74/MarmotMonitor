//
//  BabyBirthdayView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/11/2024.
//

import SwiftUI

/// A view that displays an onboarding screen to select a baby's birthday.
/// - Parameters:
///   - action: A closure executed when the user confirms the selection.
///   - actionBack: A closure executed when the user wants to go back.
///   - babyBirthday: A binding to the baby's birthday date.
/// - Returns: A fully styled view.
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

                        MarmotImageView()
                    }

                    OnBoardingConfirmButton(
                        confirmAction: action,
                        text: "C'est parti !"
                    )
                }
                .padding(.horizontal, 20)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .overlay(alignment: .topLeading) {
            BackButton(action: actionBack)
                .padding()
        }
    }

    /// The image of the marmot displayed in the onboarding view.
        var marmotImage: some View {
            HStack {
                Spacer()
                Image(decorative: "marmotWithPen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.horizontal, 20)
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
