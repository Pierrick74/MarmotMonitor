//
//  TodayView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 08/11/2024.
//

import SwiftUI
import PhotosUI

struct TodayView: View {
    var percentageHeight: CGFloat = 0.5
    @State private var contentOffset: CGFloat = .zero

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    ScrollView {
                        TodayDetailsView()
                            .padding(.top, proxy.size.height * percentageHeight + 14)
                            .background(
                                GeometryReader(content: { geo in
                                Color.clear.preference(key: ContentOffSetKey.self, value: geo.frame(in: .named("scrolView")).minY)
                            })
                        )
                    }
                    .scrollIndicators(.hidden)
                    .coordinateSpace(name: "scrollView")
                    .onPreferenceChange(ContentOffSetKey.self) { value in
                        contentOffset = value * 1.2
                    }
                }
                VStack {
                    TodayHeaderView(size: proxy.size,
                                    safeAreaInsets: proxy.safeAreaInsets,
                                    percentageHeight: percentageHeight,
                                    contentOffset: $contentOffset)
                    Spacer()
                }
            }
            .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct ContentOffSetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

#Preview {
    TodayView()
}
