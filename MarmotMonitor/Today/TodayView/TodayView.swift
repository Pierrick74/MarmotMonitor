//
//  TodayView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI
import PhotosUI

struct TodayView: View {
    @State private var photo: PhotosPickerItem?
    @State private var selectedImage: Image = Image("todayDefault")

    @Environment(\.colorScheme) var colorScheme

    var manager = TodayViewManager()

    @MainActor
    init(manager: TodayViewManager? = nil) {
        if let unwrapManager = manager {
            self.manager = unwrapManager
        }
    }

    var body: some View {
            ScrollView {
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        PhotosPicker(selection: $photo,
                                     matching: .images) {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .frame(maxWidth: UIScreen.main.bounds.width)
                                .clipped()
                        }
                                     .accessibilityHidden(true)

                        ZStack {
                            BackgroundColor()

                            VStack(spacing: 15) {

                                TodayStripName()
                                    .padding(.top, 7)

                                RowView(activity: manager.lastDiaperActivity, category: .diaper)
                                    .padding(.horizontal, 5)

                                RowView(activity: manager.lastSleepActivity, category: .sleep)
                                    .padding(.horizontal, 5)

                                RowView(activity: manager.lastFoodActivity, category: .food)
                                    .padding(.horizontal, 5)

                                RowView(activity: manager.lastGrowthActivity, category: .growth)
                                    .padding(.horizontal, 5)
                                Spacer(minLength: 40)
                            }
                        }
                        .cornerRadius(30)
                        .offset(y: -30)
                    }
                    .ignoresSafeArea()
                    .onChange(of: photo) { _, newPhoto in
                        if let newPhoto {
                            Task {
                                selectedImage = await newPhoto.convert()
                            }
                        }
                    }

                    HStack {
                        Spacer()

                            ZStack {

                                Image(systemName: "photo")
                                    .tint(colorScheme == .light ? .black : .white)

                                    .offset(x: colorScheme == .light ? 0.5 : 0.5,
                                            y: colorScheme == .light ? 0.5 :  0.5)
                                Image(systemName: "photo")

                            }
                                     .padding(13)
                                     .clipShape(Circle())
                                     .background(Circle()
                                        .fill(colorScheme == .light ? .white : .black))
                                     .background(Circle()
                                        .fill(colorScheme == .light ? .black : .clear)
                                        .offset(x: 1, y: 2))
                                     .padding(.horizontal, 15)
                                     .allowsHitTesting(false)
                    }
                    .padding(.top, 47)
                    .accessibilityHidden(true)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .ignoresSafeArea()
        }
}

#Preview {
    TodayView()
}
