//
//  TimerView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/12/2024.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let timer: TimerObject
    let color: Color
    let title: String

    var body: some View {
        if dynamicTypeSize < .accessibility1 {
            VStack {
                Text(title)
                    .font(.title2)
                    .padding(.top, 10)

                Text(timer.displayTime())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .contentTransition(.numericText())
                    .animation(.linear, value: timer.timeElapsed)
                    .padding(.bottom, 10)

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
                .buttonStyle(ShadowToggleButtonStyle(color: color))

                Button {
                    timer.resetTimer()
                } label: {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .shadow(radius: 1, x: 1, y: 1)
                        .padding(5)
                }
            }
            .frame(maxWidth: .infinity)

        } else {
            VStack {
                    Text(title)
                        .font(.title2)
                        .padding(.top, 10)
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
                    .buttonStyle(AccessibilityShadowToggleButtonStyle(color: color))

                    Text(timer.displayTime())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                        .animation(.linear, value: timer.timeElapsed)
                        .padding(.bottom, 10)

                    Button {
                        timer.resetTimer()
                    } label: {
                        Text("Reset")
                            .font(.title)
                            .foregroundColor(.primary)
                            .shadow(radius: 1, x: 1, y: 1)
                    }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
        }
    }
}

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
    TimerView(timer: TimerObject(), color: .blue, title: "Gauche")
}
