//
//  BackgroundColor.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//
import SwiftUI

struct BackgroundColor: View {
    private var manager = AppStorageManager.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: [manager.gender == GenderType.boy.rawValue ?  .pastelBlueToEgiptienBlue : .pinkToEgiptienBlue,
                                        .whiteToEgiptienBlue]),
            center: .top,
            startRadius: 0,
            endRadius: 400
        )
        .edgesIgnoringSafeArea(.all)
    }
}
