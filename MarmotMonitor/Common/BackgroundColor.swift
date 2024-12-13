//
//  BackgroundColor.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//
import SwiftUI

struct BackgroundColor: View {
    @ObservedObject private var manager = AppStorageManager.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors:
                                [manager.gender == GenderType.boy ?  .pastelBlueToEgiptienBlue : .pinkToEgiptienBlue,
                                    .whiteToEgiptienBlue]),
                          startPoint: .top,
                            endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
    }
}
