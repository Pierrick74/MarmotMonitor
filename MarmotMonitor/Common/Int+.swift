//
//  Int+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2024.
//

import Foundation

extension Int {
    /// convert number in String  HH:mm:
    func toHourMinuteString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}
