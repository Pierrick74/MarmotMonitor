//
//  GenderView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/11/2024.
//

import SwiftUI

struct GenderView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let action: () -> Void

    @Binding var gender: String

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.25)

                    ZStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Spacer()
                                .frame(height: 10)

                            Text("La petite marmotte est-elle un garçon ou une fille ? ")
                                .font(.body)
                                .padding(.bottom, 10)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .accessibilityHidden(true)

                            GenderPicker(selection: $gender)
                                .padding(.horizontal)
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
    GenderView(action: {}, gender: .constant("Garçon"))
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
