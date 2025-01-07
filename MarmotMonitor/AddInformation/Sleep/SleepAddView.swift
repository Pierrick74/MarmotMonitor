//
//  SleepView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/11/2024.
//

import SwiftUI
/// A view for adding sleep data, including start and end times.
/// - Uses date pickers for time selection and allows the user to save the sleep session.
/// - Parameters:
///   - dismiss: A function to dismiss the view.
///   - dynamicTypeSize: Adjusts the view to match the user's preferred text size.
/// - Returns: A SwiftUI `View` for sleep data input.
struct SleepAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @StateObject var manager = SleepAddViewManager()

    // sheet presentation
    @State private var isStartPickerPresented: Bool = false
    @State private var isEndPickerPresented: Bool = false
    @State private var showingAlert: Bool = false

    var body: some View {
        ZStack {
            BackgroundColor()

            ScrollView {
                VStack(spacing: 30) {
                    headerImage

                    Text("Sélectionne le sommeil")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    dateSelectionViews

                    Spacer()

                    SaveButtonView {
                        manager.saveSleep()

                        if manager.isSaveError == false {
                            dismiss()
                        } else {
                            showingAlert = true
                        }
                    }
                    .allowsHitTesting(manager.isActiveButtonSave)
                }
                .padding()
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        .sheet(isPresented: $isStartPickerPresented) {
            PickerDateSheetView(
                title: "Select Start Time",
                selectedDate: $manager.startDate,
                isPresented: $isStartPickerPresented,
                range: manager.startRange
            )
            .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
            .environment(\.dynamicTypeSize, dynamicTypeSize)
            .presentationCornerRadius(30)
        }

        .sheet(isPresented: $isEndPickerPresented) {
            PickerDateSheetView(
                title: "Select End Time",
                selectedDate: $manager.endDate,
                isPresented: $isEndPickerPresented,
                range: manager.endRange
            )
            .presentationDetents(dynamicTypeSize < .accessibility1 ? [.medium] : [.large])
            .environment(\.dynamicTypeSize, dynamicTypeSize)
            .presentationCornerRadius(30)
        }
        .alert(
            "Alerte",
            isPresented: $showingAlert
        ) {
            Button("OK", role: .cancel) {
                showingAlert = false
            }
        } message: {
            Text(manager.alertMessage)
        }
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    /// Displays the header image for the view (if applicable based on dynamic type size).
    private var headerImage: some View {
        Group {
            if dynamicTypeSize < .accessibility1 {
                Image(decorative: "Sommeil")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.teal)
            }
        }
    }

    /// Displays the date selection views for start and end times.
    private var dateSelectionViews: some View {
        VStack(spacing: 30) {
            DateSelectionView(
                title: "Heure de début",
                date: manager.startDate,
                buttonAction: { isStartPickerPresented = true }
            )
            .accessibilityLabel("Sélectionnez l'heure de début")
            .accessibilityHint(manager.accessibilityHintForStartDate)

            DateSelectionView(
                title: "Heure de fin",
                date: manager.endDate,
                buttonAction: { isEndPickerPresented = true }
            )
            .accessibilityLabel("Sélectionnez l'heure de fin")
            .accessibilityHint(manager.accessibilityHintForEndDate)
        }
    }
}

#Preview {
    SleepAddView()
}
