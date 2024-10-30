//
//  OnBoardingView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI

struct OnBoardingView: View {
    @StateObject var manager = OnBoardingManager()
    @State private var isShowPrevButton = false

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)

            TabView(selection: $manager.activeScreen) {
                Button(action: manager.next) {
                    Text("Next")
                }
                    .tag(OnBoardingManager.Screen.welcome.rawValue)
                Text("Baby Name")
                    .tag(OnBoardingManager.Screen.babyName.rawValue)
                Text("Gender")
                    .tag(OnBoardingManager.Screen.gender.rawValue)
                Text("Parent Name")
                    .tag(OnBoardingManager.Screen.parentName.rawValue)
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .overlay(alignment: .topLeading) {
            if isShowPrevButton {
                Button(action: manager.previous) {
                    Image(systemName: "chevron.backward.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .padding()
                }
            }
        }
        .onChange(of: manager.activeScreen) {
            withAnimation {
                if manager.activeScreen == OnBoardingManager.Screen.allCases.first!.rawValue {
                    isShowPrevButton = false
                } else {
                    isShowPrevButton = true
                }
                print("activeScreen: \(manager.activeScreen)")
                print("isShowPrevButton: \(isShowPrevButton)")
            }
        }
        // Disable scroll to manage with Button
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false
        }
        .onDisappear {
            UIScrollView.appearance().isScrollEnabled = true
        }
    }
}

#Preview {
    OnBoardingView()
}
