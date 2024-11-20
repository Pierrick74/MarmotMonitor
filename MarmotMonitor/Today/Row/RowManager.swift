//
//  RowManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/11/2024.
//

import SwiftUI

final class RowManager {
    var activity: Activity

    init(activity: Activity) {
        self.activity = activity
    }

    var title: String {
        return activity.title
    }

    var lastActivity: String {
        return "Il y a 3 jours"
    }

    var information: String {
        return "30 min"
    }

    var accessibilityDescription: String {
        return title + " " + lastActivity + " " + information
    }

    var imageName: String {
        return activity.imageName
    }

    var color: Color {
        return activity.color
    }
}
