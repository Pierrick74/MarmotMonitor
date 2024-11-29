//
//  BottleAddView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 28/11/2024.
//

import SwiftUI

struct BottleAddView: View {
    @StateObject var manager = BottleAddViewManager()

    var body: some View {
        GeometryReader { geo in
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let relativeY = 1.0 - Double(value.location.y / geo.size.height) - 0.17
                    let acceleratedAmount = relativeY * 2
                    let amount = max(0, min(100, acceleratedAmount * 100))
                    manager.setPercent(amount)
                }
            ZStack {
                VStack {
                    ZStack(alignment: .bottom) {
                        VStack {

                            WaveAnimation(percent: $manager.percent)
                                .frame(height: geo.size.height * 0.45)
                                .overlay {
                                    Text(manager.volume)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }

                            Rectangle()
                                .frame(height: geo.size.height * 0.195)
                        }

                        VStack(spacing: 0) {
                            ZStack {
                                BackgroundColor()

                                VStack {
                                    Spacer()
                                    Image(decorative: "biberonForFill")
                                        .resizable()
                                        .frame(width: 200, height: geo.size.height * 0.7)
                                        .blendMode(.destinationOut)
                                    Spacer()

                                    SaveButtonView(onSave: {})
                                }
                            }
                            .compositingGroup()
                        }
                        .shadow(radius: 20, x: 5, y: 5)

                        Rectangle()
                            .opacity(0.00001)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .gesture(dragGesture)
                    }
                }
            }
        }
    }
}

#Preview {
    BottleAddView()
}
