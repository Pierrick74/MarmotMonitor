//
//  GenderView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/11/2024.
//

import SwiftUI
/// A view that allows the user to select the gender of the baby.
/// - Parameters:
///   - action: A closure executed when the user confirms the selection.
///   - actionBack: A closure executed when the user navigates back.
///   - gender: A binding to the selected `GenderType`.
/// - Returns: A styled onboarding view.
struct GenderView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let action: () -> Void
    let actionBack: () -> Void

    @Binding var gender: GenderType

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.30)

                    ZStack(alignment: .top) {
                        genderSelectionSection
                        MarmotImageView()
                    }

                    OnBoardingConfirmButton(
                        confirmAction: action,
                        text: "Suivant"
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

    private var genderSelectionSection: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 10)

            Text("La petite marmotte est-elle un garçon ou une fille ? ")
                .onBoardingTextStyle()

            GenderPicker(selection: $gender)
                .padding(.horizontal)
        }
        .onBoardingBackground()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GenderView(action: {}, actionBack: {}, gender: .constant(.boy))
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
