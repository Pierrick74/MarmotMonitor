//
//  RowView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2024.
//

import SwiftUI
/// A view that represents a row displaying baby activity information.
/// - Parameters:
///  - activity: The baby activity to display.
///  - category: The category of the activity.
///  - Returns: A row view displaying the baby activity information.
///  - Note: The row view adjusts its layout based on the dynamic type size.
struct RowView: View {
    var manager: RowManager
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    init(activity: BabyActivity?, category: ActivityCategory) {
        self.manager = RowManager(babyActivity: activity, category: category)
    }

    var body: some View {
        ZStack( alignment: .bottom) {
            Rectangle()
                .background(manager.color)
                .cornerRadius(25)
                .frame(height: 80)
                .offset(x: 1, y: 2)

            Group {
                if dynamicTypeSize < .accessibility1 {
                    compactLayout
                } else {
                    expandedLayout
                }
            }
            .padding(.horizontal, 10)
            .background(manager.color)
            .cornerRadius(25)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(manager.accessibilityDescription)
    }

    // MARK: - Private Views
    private var compactLayout: some View {
        ZStack(alignment: .center) {
            compactIcon
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    title
                    lastActivity
                }
                Spacer()
                Text(manager.information)
                    .bold()
            }
            .padding(.horizontal)
        }
    }

    private var expandedLayout: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading) {
                title
                lastActivity
                Text(manager.information.replacingOccurrences(of: "\n", with: " "))
            }
            .frame(maxWidth: .infinity)
        }
    }

    /// A view that displays the  icon in a compact layout
    private var compactIcon: some View {
        HStack {
            Spacer()
            Spacer()
            Image(manager.imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .clipped()
            Spacer()
        }
    }

    private var title: some View {
        Text(manager.title)
            .font(.title)
            .foregroundColor(.primary)
    }

    private var lastActivity: some View {
        Text(manager.lastActivity)
            .font(.subheadline)
            .foregroundColor(.primary)
    }
}

#Preview {
    RowView(activity: BabyActivity(activity: .growth(data: GrowthData(weight: 19,
                                                                      height: 70,
                                                                      headCircumference: nil)), date: .now),
            category: .growth)
}
