//
//  BabyNameView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/11/2024.
//

import SwiftUI

struct BabyNameView: View {
    @Environment(\.colorScheme) var colorScheme

    let action: () -> Void
    @State private var name = ""

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

                            TextField("Nom", text: $name)
                                .padding()
                                .frame(maxWidth: .infinity)
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
