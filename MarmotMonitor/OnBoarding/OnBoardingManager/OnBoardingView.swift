//
//  OnBoardingView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 29/10/2024.
//

import SwiftUI
// manage the onboarding screen

struct OnBoardingView: View {
    @StateObject var manager = OnBoardingManager()
    @State private var isShowPrevButton = false

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [.pastelBlueToEgiptienBlue, .whiteToEgiptienBlue]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)

            VStack {
                TabView(selection: $manager.activeScreen) {
                    WelcomeView(action: manager.next)
                        .tag(OnBoardingManager.Screen.welcome.rawValue)
                    Text("Baby Name")
                        .tag(OnBoardingManager.Screen.babyName.rawValue)
                    Text("Gender")
                        .tag(OnBoardingManager.Screen.gender.rawValue)
                    Text("Parent Name")
                        .tag(OnBoardingManager.Screen.parentName.rawValue)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .accessibilityLabel("Page \(String(describing: OnBoardingManager.Screen(rawValue: manager.activeScreen)!.title))")

                CustomPageIndicator(numberOfPages: OnBoardingManager.Screen.allCases.count,
                                        currentPage: $manager.activeScreen,
                                    color: .secondary)
                .padding(.top, 20)
            }
        }
        .overlay(alignment: .topLeading) {
            if isShowPrevButton {
                Button(action: manager.previous) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(colorScheme == .light ? .blue.opacity(0.6) : .white.opacity(0.6))
                        .background(Circle().fill(.whiteToEgiptienBlue)
                                        .shadow(color: colorScheme == .light ? .gray : .clear
                                                , radius: 2, x: 2, y: 2)
                                        .shadow(color: .white, radius: 2)
                                        .frame(width: 35, height: 35))
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .padding(30)
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
