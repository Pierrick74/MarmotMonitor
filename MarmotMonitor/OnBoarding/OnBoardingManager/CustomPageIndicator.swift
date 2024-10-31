//
//  CustomPageIndicator.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 31/10/2024.
//

import SwiftUI

struct CustomPageIndicator: View {
    let numberOfPages: Int
    @Binding var currentPage: Int
    let color: Color

    var body: some View {

        HStack(spacing: 12) {
            ForEach(0..<numberOfPages, id: \.self) { page in
                if page == currentPage {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                        .frame(width: 36, height: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(color.opacity(0.3), lineWidth: 2)
                        )
                        .scaleEffect(page == currentPage ? 1.2 : 1.0)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .scaleEffect(page == currentPage ? 1.2 : 1.0)
                }
            }
        }
        .padding(.vertical, 20)
        .accessibilityLabel("Page \(currentPage + 1) de \(numberOfPages)")
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CustomPageIndicator(numberOfPages: 5, currentPage: .constant(2), color: .red)
}
