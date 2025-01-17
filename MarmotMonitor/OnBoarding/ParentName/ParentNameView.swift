//
//  ParentNameView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/11/2024.
//

import SwiftUI

/// A view for entering the parent's name during onboarding.
/// - Parameters:
///   - action: A closure executed when the user confirms the input.
///   - actionBack: A closure executed when the user navigates back.
///   - parentName: A binding to the parent's name input.
///   - valideName: A binding to the validation state of the parent's name.
/// - Returns: A fully styled onboarding view for parent name entry.
struct ParentNameView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // MARK: - Properties
    let action: () -> Void
    let actionBack: () -> Void
    @Binding var parentName: String
    @Binding var valideName: Bool

    @State private var showAlerte = false
    private var placeholderOfTextField: String {
        return dynamicTypeSize > .xxLarge ? "Nom" : "Nom du parent"
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.30)

                    ZStack(alignment: .top) {
                        inputView
                        MarmotImageView()
                    }

                    OnBoardingConfirmButton(
                        confirmAction: {
                            self.dismissKeyboard()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
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
                    DispatchQueue.main
                        .asyncAfter(deadline: .now() + 0.7) {
                    actionBack()
                }
            })
            .padding()
        }
    }

    private var inputView: some View {
        VStack(alignment: .leading) {

            Text("Quel est le nom du Parent ? ")
                .onBoardingTextStyle()
                .accessibilityHidden(true)

            TextField(placeholderOfTextField, text: $parentName)
                .tint(.primary)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 14).fill(.pastelBlueToEgiptienBlue.opacity(0.35)))
                .padding(.horizontal)
                .accessibilityLabel("Inserer le nom du Parent ? ")
                .accessibilityValue(parentName)

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

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ParentNameView(action: {}, actionBack: {}, parentName: .constant(""), valideName: .constant(false))
            .preferredColorScheme(.light)
            .background(LinearGradient(gradient:
                                        Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
                           )
}
