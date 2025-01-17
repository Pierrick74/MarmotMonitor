//
//  WelcomeView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 31/10/2024.
//

import SwiftUI
/// A view that welcomes the user to the app and provides an introduction to its purpose.
/// - Parameters:
///   - action: A closure executed when the user taps the "Commencer" button.
/// - Returns: A styled onboarding welcome view.
struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme

    let action: () -> Void

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.30)

                    ZStack(alignment: .top) {
                        textSection
                        MarmotImageView()
                    }

                    OnBoardingConfirmButton(
                        confirmAction: action,
                        text: "Commencer"
                    )
                }
                .padding(.horizontal, 20)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }

    private var textSection: some View {
        VStack(alignment: .leading) {
            Text("Bienvenue")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 10)
            Text("MarmotMonitor est une application qui vous permet de suivre la croissance de votre bébé.")
                .onBoardingTextStyle()
            Text("Je vais t'aider à créer ton espace personnalisé.")
                .onBoardingTextStyle()
        }
        .onBoardingBackground()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
        WelcomeView(action: {})
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
