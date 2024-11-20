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
            BackgroundColor()

            VStack {
                TabView(selection: $manager.activeScreen) {
                    WelcomeView(action: manager.next)
                        .tag(OnBoardingManager.Screen.welcome.rawValue)
                    BabyNameView(action: manager.next,
                                 actionBack: manager.previous,
                                 babyName: $manager.babyName,
                                 valideName: $manager.isBabyNameValide)
                    .tag(OnBoardingManager.Screen.babyName.rawValue)
                    GenderView(action: manager.next,
                               actionBack: manager.previous,
                               gender: $manager.gender)
                    .tag(OnBoardingManager.Screen.gender.rawValue)
                    ParentNameView(action: manager.next,
                                   actionBack: manager.previous,
                                   parentName: $manager.parentName,
                                   valideName: $manager.isParentNameValide)
                    .tag(OnBoardingManager.Screen.parentName.rawValue)
                    BabyBirthdayView(action: manager.next, actionBack: manager.previous, babyBirthday: $manager.babyBirthday)
                        .tag(OnBoardingManager.Screen.babyBirthday.rawValue)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .accessibilityLabel("Page \(String(describing: OnBoardingManager.Screen(rawValue: manager.activeScreen)!.title))")

                CustomPageIndicator(numberOfPages: OnBoardingManager.Screen.allCases.count,
                                    currentPage: $manager.activeScreen,
                                    color: .secondary)
                .padding(.top, 20)
                .allowsHitTesting(false)
            }
        }
        // Disable scroll to manage with Button
        .onAppear {
                UIScrollView.appearance().isScrollEnabled = false
        }
        .onDisappear {
            UIScrollView.appearance().isScrollEnabled = true
        }
        .onChange(of: manager.activeScreen) {
            if manager.activeScreen == OnBoardingManager.Screen.babyBirthday.rawValue {
                UIScrollView.appearance().isScrollEnabled = true
            } else {
                UIScrollView.appearance().isScrollEnabled = false
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
