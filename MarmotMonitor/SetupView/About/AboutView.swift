//
//  AboutView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2025.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Inconnue"

    var body: some View {
        ZStack {
            BackgroundColor()
            VStack {
                Image(.marmotWithPen)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                Text("Marmot Monitor")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Version : \(appVersion)")
                    .font(.title2)
                    .padding(.top, 5)
            }
        }
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AboutView()
}
