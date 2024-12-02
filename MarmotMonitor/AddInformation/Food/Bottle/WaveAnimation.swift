//
//  WaveAnimation.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/11/2024.
//

import SwiftUI
/// This view is used to display a wave animation
/// The wave will move according to the value of the percent variable
/// Show the value of the percent variable in ml in the center of the wave
///
struct WaveAnimation: View {
    @Binding var percent: Double
    @State private var waveOffset = Angle(degrees: 0)

    var body: some View {
            Wave(percent: percent, offSet: Angle(degrees: waveOffset.degrees))
                .fill(Color.blue)
                .ignoresSafeArea(.all)
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct Wave: Shape {
    var percent: Double
    var offSet: Angle

    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let lowestWave = 0.02
        let highestWave = 1.00

        let newPercent = lowestWave + (highestWave - lowestWave) * percent / 100
        let waveHeight = rect.height * 0.015
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)

        path.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))

        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let xValue = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            path.addLine(to: CGPoint(x: xValue, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}

#Preview {
    WaveAnimation(percent: .constant(50))
}
