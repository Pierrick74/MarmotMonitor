//
//  TextField.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/11/2024.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
