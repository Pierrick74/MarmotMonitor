//
//  BabyNameView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/11/2024.
//

import SwiftUI

struct BabyNameView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var textOfTextField: String {
        return dynamicTypeSize > .xxLarge ? "Nom" : "Nom du bébé"
    }

    let action: () -> Void
    @State private var text = ""

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.25)

                    ZStack(alignment: .top) {
                        VStack(alignment: .leading) {

                            Text("Quelle est le nom de la petite marmotte ? ")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.bottom, 10)
                                .multilineTextAlignment(.leading)
                                .accessibilityHidden(true)

                            TextField(textOfTextField, text: $text)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 14).fill(.pastelBlueToEgiptienBlue.opacity(0.35)))
                                .padding(.horizontal)
                                .accessibilityLabel("Inserer le nom de la petite marmotte ? ")
                                .accessibilityValue(text)
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
                        Text("Suivant")
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
    BabyNameView(action: {})
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
