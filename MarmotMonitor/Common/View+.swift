//
//  View+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2025.
//

import SwiftUI

extension View {
    var sheetStyle: some View {
        self
            .presentationDetents([.medium, .large])
            .environment(\.dynamicTypeSize, .large)
            .presentationCornerRadius(30)
    }
}
