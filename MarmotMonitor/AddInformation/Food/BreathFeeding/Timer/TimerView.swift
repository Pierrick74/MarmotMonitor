//
//  TimerView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Binding var timer: TimerObject
    let color: Color
    let title: String

    var body: some View {
            VStack {
                titleView
                timeDisplay

                if dynamicTypeSize < .accessibility1 {
                    timerButton
                        .buttonStyle(ShadowToggleButtonStyle(color: color))
                } else {
                    timerButton
                        .buttonStyle(AccessibilityShadowToggleButtonStyle(color: color))
                }

                resetButton
            }
            .padding(10)
            .frame(maxWidth: .infinity)
    }

    private var titleView: some View {
        Text(title)
            .font(.title2)
            .padding(.top, 10)
            .accessibilityHidden(true)
    }

    private var timeDisplay: some View {
        Text(timer.displayTime())
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .contentTransition(.numericText())
            .animation(.linear, value: timer.timeElapsed)
            .padding(.bottom, 10)
            .accessibilityLabel(timer.displayTimeAccessibility())
            .accessibilityAddTraits(.updatesFrequently)
    }

    private var resetButton: some View {
        Button {
            timer.resetTimer()
        } label: {
            Text("Reset")
                .font(.headline)
                .foregroundColor(.primary)
                .shadow(radius: 1, x: 1, y: 1)
        }
        .accessibilityLabel("remettre à zero le timer \(title)")
    }

    private var timerButton: some View {
        Button {
            if timer.isRunning {
                timer.stopTimer()
            } else {
                timer.startTimer()
            }
        } label: {
            Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .accessibilityLabel(timer.isRunning ? "mettre en Pause le timer \(title)" : "lancer le timer \(title)")
    }

}

/// Button Style for the timer button for dynamic type sizes less than accessibility1
struct ShadowToggleButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(15)
            .background(
                Circle()
                    .fill(color)
                    .stroke(colorScheme == .light ? .clear : Color.primary, lineWidth: 2)
                    .shadow(color: configuration.isPressed ? .clear : .black.opacity(0.5), radius: 3, x: 3, y: 3)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Button Style for the timer button for dynamic type sizes more than accessibility1
struct AccessibilityShadowToggleButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 40)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(color)
                    .stroke(colorScheme == .light ? .clear : Color.primary, lineWidth: 2)
                    .shadow(color: configuration.isPressed ? .clear : .black.opacity(0.5), radius: 3, x: 3, y: 3)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    @Previewable @State var timer = TimerObject()
    TimerView(timer: $timer, color: .blue, title: "Gauche")
}
