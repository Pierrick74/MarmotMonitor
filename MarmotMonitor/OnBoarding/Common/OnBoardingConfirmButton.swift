//
//  OnBoardingConfirmButton.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 17/01/2025.
//

import SwiftUI
/// View that represents the confirm button
/// Parameters:
/// - confirmAction: the action to perform when the button is tapped
/// - text: the text to display on the button
/// 
struct OnBoardingConfirmButton: View {
    var confirmAction: () -> Void
    let text: String
    var body: some View {
        Button(action: confirmAction) {
            Text(text)
        }
        .buttonStyle(OnBoardingButtonStyle())
    }
}

#Preview {
    OnBoardingConfirmButton(confirmAction: {}, text: "coucou")
}
