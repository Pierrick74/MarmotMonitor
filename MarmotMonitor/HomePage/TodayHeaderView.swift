//
//  TodayHeaderView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/11/2024.
//

import SwiftUI
/// A view that displays the header of the details view
/// - Note: The header view is composed of an image and text
/// - Note: The header view is animated based on the content offset
/// - Note: The header view is clipped to the size of the screen
struct TodayHeaderView: View {
    let size: CGSize
    let safeArea: EdgeInsets
    private let minHeight: CGFloat
    let percentageHeight: CGFloat
    let minImageHeight: CGFloat = 52

    @State private var progress: CGFloat = .zero
    @Binding var contentOffset: CGFloat

    init(
        size: CGSize,
        safeAreaInsets: EdgeInsets,
        percentageHeight: CGFloat,
        contentOffset: Binding<CGFloat>
    ) {
        self.size = size
        self.safeArea = safeAreaInsets
        self.percentageHeight = percentageHeight
        self._contentOffset = contentOffset
        self.minHeight = 60 + safeArea.top
    }

    var body: some View {
        ZStack {
            GeometryReader {
                let rect = $0.frame(in: .global)
                Image(decorative: "todayDefault").resizable().scaledToFill()
                    .frame(width: rect.size.width + (minImageHeight - rect.width) * progress,
                           height: rect.size.height + (minImageHeight - rect.height) * progress)
                    .clipShape(
                        .rect(cornerRadius: 120 * progress)
                    )
                    .offset(x: minImageHeight * progress, y: (safeArea.top - 4) * progress)
                    .onChange(of: contentOffset) {
                        progress = min(max(-contentOffset / (size.height * percentageHeight - minHeight), 0), 1)
                    }
            }
            VStack(alignment: .leading) {
                Spacer()
                TodayStripName(progress: $progress)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .scaleEffect(1 - 0.4 * progress, anchor: .leading)
            .offset(x: 100 * progress)
            .padding(.bottom, max(10 - progress * 100, 0))
        }
        .frame(height: height())
        .clipped()
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(1 * progress)
        )
    }
}

extension TodayHeaderView {
    // MARK: - Methods
    /// Calculate the height of the header view
    /// - Returns: The height of the header view
    /// - Note: The height of the header view is calculated based on the percentage height and content offset
    /// - Note: The height of the header view is limited by the minimum height
    func height() -> CGFloat {
        size.height * percentageHeight + contentOffset < minHeight
            ? minHeight
            : size.height * percentageHeight + contentOffset
    }
}

#Preview {
    TodayView()
}
