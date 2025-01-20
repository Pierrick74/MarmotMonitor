//
//  InformationView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/12/2024.
//

import SwiftUI
/// A view for displaying and editing user information.
/// - Allows modification of the child's name, birthday, gender, and parent's name.
/// - Provides a save button to persist changes.
struct InformationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = InformationViewManager()

    var body: some View {
        ZStack {
            BackgroundColor()
            ScrollView {
                VStack(spacing: 20) {
                    Text("Information")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(20)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Nom de l'enfant")
                        TextField("Nom de l'enfant", text: $manager.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .tint(.primary)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date de naissance")
                        DatePicker("", selection: $manager.babyBirthday, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date de naissance")
                        GenderPicker(selection: $manager.gender)
                            .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Nom du parent")
                        TextField("Nom du parent", text: $manager.parentName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .tint(.primary)
                    }

                    Spacer()
                    SaveButtonView {
                        manager.saveInformation()
                        dismiss()
                    }
                    .padding(.top, 20)
                }
                .padding()
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

#Preview {
    InformationView()
}
