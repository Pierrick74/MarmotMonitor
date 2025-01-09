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
    private var placeholderOfTextField: String {
        return dynamicTypeSize > .xxLarge ? "Nom" : "Nom du bébé"
    }

    let action: () -> Void
    let actionBack: () -> Void

    @Binding var babyName: String
    @Binding var valideName: Bool?
    @State private var showAlerte = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.30)

                    ZStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Quel est le nom de la petite marmotte ? ")
                                .onBoardingTextStyle()
                                .accessibilityHidden(true)

                            TextField(placeholderOfTextField, text: $babyName)
                                .tint(.primary)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 14).fill(.pastelBlueToEgiptienBlue.opacity(0.35)))
                                .padding(.horizontal)
                                .accessibilityLabel("Inserer le nom de la petite marmotte ? ")
                                .accessibilityValue(babyName)

                            Text("Le nom doit contenir au moins 2 caractères")
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 10)
                                .multilineTextAlignment(.center)
                                .opacity(showAlerte ? 1 : 0)
                                .offset(y: showAlerte ? 0 : -20)
                                .animation(showAlerte ? .easeInOut : .none, value: showAlerte)
                        }
                        .onBoardingBackground()
                        .onChange(of: valideName) {
                            let valide = valideName ?? false
                            showAlerte = !valide
                        }

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

                    Button {
                        self.dismissKeyboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            action()
                        }
                    } label: {
                        Text("Suivant")
                    }
                    .buttonStyle(OnBoardingButtonStyle())
                    .disabled(valideName == false)
                }
                .padding(.horizontal, 20)
            }
            .scrollBounceBehavior(.basedOnSize)
            .onTapGesture {
                self.dismissKeyboard()
            }
        }
        .overlay(alignment: .topLeading) {
            Button {
                self.dismissKeyboard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    actionBack()
                }
            } label: {
                Image(systemName: "chevron.backward")
            }
            .buttonStyle(OnBoardingBackButtonStyle())
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BabyNameView(action: {}, actionBack: {}, babyName: .constant(""), valideName: .constant(false))
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
