//
//  MarmotImageView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 17/01/2025.
//

import SwiftUI

/// View that represents the marmot image view
/// Parameters:
/// - none
struct MarmotImageView: View {
    var body: some View {
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
}

#Preview {
    MarmotImageView()
}
