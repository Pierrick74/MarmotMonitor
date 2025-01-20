//
//  TodayView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI
import PhotosUI
// A view that displays the main screen for today's baby activity summary.
/// - Features a photo picker, activity rows (diaper, sleep, food, growth), and a header strip.
/// - Automatically refreshes data and updates the image when changed.
struct TodayView: View {
    // MARK: - Properties
    @State private var photo: PhotosPickerItem?

    @Environment(\.colorScheme) var colorScheme

    // MARK: - dependencies
    @StateObject var manager = TodayViewManager()

    // MARK: - Body
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    photoPicker
                        .overlay(alignment: .topTrailing) {
                            photoIcon
                        }
                    activitySection
                }
                .ignoresSafeArea()
                .onChange(of: photo) { _, newPicture in
                    manager.changePicture(newPicture)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .ignoresSafeArea()
        .onAppear {
            manager.refreshData()
        }
    }

    // MARK: - private Views
    private var photoPicker: some View {
        PhotosPicker(selection: $photo, matching: .images) {
            manager.selectedImage
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .clipped()
        }
        .accessibilityHidden(true)
    }

    private var activitySection: some View {
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
                Spacer(minLength: 50)
            }
        }
        .cornerRadius(30)
        .offset(y: -30)
    }

    private var photoIcon: some View {
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
        .padding(25)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

#Preview {
    TodayView()
}
