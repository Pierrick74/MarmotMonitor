//
//  WelcomeView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 31/10/2024.
//

import SwiftUI

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
                        VStack(alignment: .leading) {
                            Text("Bienvenue")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                            Text("MarmotMonitor est une application qui vous permet de suivre la croissance de votre bébé.")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                                .multilineTextAlignment(.leading)
                            Text("Je vais t'aider à créer ton espace personnalisé.")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                                .multilineTextAlignment(.leading)
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
                        Text("Commencer")
                    }
                    .buttonStyle(OnBoardingButtonStyle())
                }
                .padding(.horizontal, 20)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
        WelcomeView(action: {})
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
