//
//  BabyNameView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/11/2024.
//

import SwiftUI

/// A view that prompts the user to input a baby's name.
/// - Parameters:
///   - action: A closure executed when the user confirms the input.
///   - actionBack: A closure executed when the user navigates back.
///   - babyName: A binding to the baby's name input.
///   - valideName: A binding to the validation state of the baby's name (true, false, or nil).
/// - Returns: A fully styled onboarding view.
struct BabyNameView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var placeholderOfTextField: String {
        return dynamicTypeSize > .xxLarge ? "Nom" : "Nom du bébé"
    }

    let action: () -> Void
    let actionBack: () -> Void

    @Binding var babyName: String
    @Binding var valideName: Bool
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
                            showAlerte = !valideName
                        }

                        MarmotImageView()
                    }

                    OnBoardingConfirmButton(
                        confirmAction: {
                            self.dismissKeyboard()
                            DispatchQueue.main
                                .asyncAfter(deadline: .now() + 0.7) {
                                    action()
                                }
                        },
                        text: "Suivant"
                    )
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
            BackButton(
                action: {
                    self.dismissKeyboard()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        actionBack()
                    }
                }
            )
            .padding()
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
